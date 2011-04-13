require 'xml'
require 'atom'
require 'digest/sha2'
require 'rsa'

module OStatus
  class Salmon
    attr_accessor :entry

    # Create a Salmon instance for a particular OStatus::Entry
    def initialize entry, signature = nil, plaintext = nil
      @entry = entry
      @signature = signature
      @plaintext = plaintext
    end

    # Generate a magic envelope from an OStatus::Entry or pull an
    # OStatus::Entry from a magic envelope
    def Salmon.from_xml source
      if source.is_a?(String)
        source = XML::Document.string(source, 
                                      :options => XML::Parser::Options::NOENT)
      end

      # Retrieve the envelope
      envelope = source.find('/me:env', 
                          'me:http://salmon-protocol.org/ns/magic-env').first

      if envelope.nil?
        return nil
      end

      data = envelope.find('me:data', 
                           'me:http://salmon-protocol.org/ns/magic-env').first
      if data.nil?
        return nil
      end

      data_type = data.attributes["type"]
      if data_type.nil?
        data_type = 'application/atom+xml'
        armored_data_type = ''
      else
        armored_data_type = Base64::urlsafe_encode64(data_type)
      end

      encoding = envelope.find('me:encoding',
                               'me:http://salmon-protocol.org/ns/magic-env').first

      algorithm = envelope.find(
                          'me:alg',
                          'me:http://salmon-protocol.org/ns/magic-env').first

      signature = source.find('me:sig',
                           'me:http://salmon-protocol.org/ns/magic-env').first

      # Parse fields

      if signature.nil?
        # Well, if we cannot verify, we don't accept
        return nil
      else
        # XXX: Handle key_id attribute
        signature = signature.content
        signature = Base64::urlsafe_decode64(signature)
      end

      if encoding.nil?
        # When the encoding is omitted, use base64url
        # Cite: Magic Envelope Draft Spec Section 3.3
        armored_encoding = ''
        encoding = 'base64url'
      else
        armored_encoding = Base64::urlsafe_encode64(encoding.content)
        encoding = encoding.content.downcase
      end

      if algorithm.nil?
        # When algorithm is omitted, use 'RSA-SHA256'
        # Cite: Magic Envelope Draft Spec Section 3.3
        armored_algorithm = ''
        algorithm = 'rsa-sha256'
      else
        armored_algorithm = Base64::urlsafe_encode64(algorithm.content)
        algorithm = algorithm.content.downcase
      end

      # Retrieve and decode data payload

      data = data.content
      armored_data = data

      case encoding
      when 'base64url'
        data = Base64::urlsafe_decode64(data)
      else
        # Unsupported data encoding
        return nil
      end

      # Signature plaintext
      plaintext = "#{armored_data}.#{armored_data_type}.#{armored_encoding}.#{armored_algorithm}"

      # Interpret data payload
      payload = XML::Reader.string(data)
      Salmon.new OStatus::Entry.new(payload), signature, plaintext
    end

    # Return the EMSA string for this Salmon instance given the size of the
    # public key modulus.
    def signature modulus_byte_length
      plaintext = Digest::SHA2.new(256).digest(@plaintext)

      prefix = "\x30\x31\x30\x0d\x06\x09\x60\x86\x48\x01\x65\x03\x04\x02\x01\x05\x00\x04\x20"
      padding_count = modulus_byte_length - prefix.bytes.count - plaintext.bytes.count - 3

      padding = ""
      padding_count.times do 
        padding = padding + "\xff"
      end

      emsa = "\x00\x01#{padding}\x00#{prefix}#{plaintext}"
    end

    def sign key
    end

    # Use RSA to verify the signature
    # key - Public key as a string of the form RSA.A.B where A and B are Base64
    #   urlsafe encoded and A is the modulus and B is the exponent
    def verified? key
      # RSA encryption is needed to compare the signatures
      # Create the public key from the key

      # Retrieve the exponent and modulus from the key string
      key.match /^RSA\.(.*?)\.(.*)$/
      modulus = Base64::urlsafe_decode64($1)
      exponent = Base64::urlsafe_decode64($2)

      modulus_byte_length = modulus.bytes.count
      modulus = modulus.bytes.inject(0) {|num, byte| (num << 8) | byte }
      exponent = exponent.bytes.inject(0) { |num, byte| (num << 8) | byte }

      # Create the public key instance
      key = RSA::Key.new(modulus, exponent)
      keypair = RSA::KeyPair.new(nil, key)

      # Get signature to check
      emsa = self.signature modulus_byte_length

      # Get signature in payload
      emsa_signature = keypair.encrypt(@signature)

      # RSA gem drops leading 0s since it does math upon an Integer
      # As a workaround, I check for what I expect the second byte to be (\x01)
      # This workaround will also handle seeing a \x00 first if the RSA gem is
      # fixed.
      if emsa_signature.getbyte(0) == 1
        emsa_signature = "\x00#{emsa_signature}"
      end

      # Does the signature match?
      # Return the result.
      emsa_signature == emsa
    end
  end
end
