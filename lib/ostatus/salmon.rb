require 'xml'
require 'atom'
require 'digest/sha2'

module OStatus
  class Salmon
    attr_accessor :entry

    # Create a Salmon instance for a particular OStatus::Entry
    def initialize entry, signature = nil, plaintext = nil
      @entry = entry
      @signature = signature
      @plaintext = plaintext
    end

    # Creates an entry for following a particular Author.
    def Salmon.from_follow(user_author, followed_author)
      entry = OStatus::Entry.new(
        :author => user_author,
        :title => "Now following #{followed_author.name}",
        :content => Atom::Content::Html.new("Now following #{followed_author.name}")
      )

      entry.activity.verb = :follow
      entry.activity_object = followed_author

      OStatus::Salmon.new(entry)
    end

    # Creates an entry for unfollowing a particular Author.
    def Salmon.from_unfollow(user_author, followed_author)
      entry = OStatus::Entry.new(
        :author => user_author,
        :title => "Stopped following #{followed_author.name}",
        :content => Atom::Content::Html.new("Stopped following #{followed_author.name}")
      )

      entry.activity_verb = "http://ostatus.org/schema/1.0/unfollow"
      entry.activity_object = followed_author

      OStatus::Salmon.new(entry)
    end

    # Creates an entry for a profile update.
    def Salmon.from_profile_update(user_author)
      entry = OStatus::Entry.new(
        :author => user_author,
        :title => "#{user_author.name} changed their profile information.",
        :content => Atom::Content::Html.new("#{user_author.name} changed their profile information.")
      )

      entry.activity_verb = "http://ostatus.org/schema/1.0/update-profile"

      OStatus::Salmon.new(entry)
    end

    # Will pull a OStatus::Entry from a magic envelope described by the xml.
    def Salmon.from_xml source
      if source.is_a?(String)
        if source.length == 0
          return nil
        end

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

    # Generate the xml for this Salmon notice and sign with the given private
    # key.
    def to_xml key
      # Generate magic envelope
      magic_envelope = XML::Document.new

      magic_envelope.root = XML::Node.new 'env'

      me_ns = XML::Namespace.new(magic_envelope.root,
                   'me', 'http://salmon-protocol.org/ns/magic-env')

      magic_envelope.root.namespaces.namespace = me_ns

      # Armored Data <me:data>
      data = @entry.to_xml
      @plaintext = data
      data_armored = Base64::urlsafe_encode64(data)
      elem = XML::Node.new 'data', data_armored, me_ns
      elem.attributes['type'] = 'application/atom+xml'
      data_type_armored = 'YXBwbGljYXRpb24vYXRvbSt4bWw='
      magic_envelope.root << elem

      # Encoding <me:encoding>
      magic_envelope.root << XML::Node.new('encoding', 'base64url', me_ns)
      encoding_armored = 'YmFzZTY0dXJs'

      # Signing Algorithm <me:alg>
      magic_envelope.root << XML::Node.new('alg', 'RSA-SHA256', me_ns)
      algorithm_armored = 'UlNBLVNIQTI1Ng=='

      # Signature <me:sig>
      plaintext = "#{data_armored}.#{data_type_armored}.#{encoding_armored}.#{algorithm_armored}"

      # Assign @signature to the signature generated from the plaintext
      sign(plaintext, key)

      signature_armored = Base64::urlsafe_encode64(@signature)
      magic_envelope.root << XML::Node.new('sig', signature_armored, me_ns)

      magic_envelope.to_s :indent => true, :encoding => XML::Encoding::UTF_8
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

      "\x00\x01#{padding}\x00#{prefix}#{plaintext}"
    end

    def sign message, key
      @plaintext = message

      modulus_byte_count = key.private_key.modulus.size

      @signature = signature(modulus_byte_count)
      @signature = key.decrypt(@signature)
    end

    # Use RSA to verify the signature
    # key - RSA::KeyPair with the public key to use
    def verified? key
      # RSA encryption is needed to compare the signatures

      # Get signature to check
      emsa = self.signature key.public_key.modulus.size

      # Get signature in payload
      emsa_signature = key.encrypt(@signature)

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
