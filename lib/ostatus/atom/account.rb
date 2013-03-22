module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus PortableContacts Account object.
    class Account
      include ::Atom::Xml::Parseable

      # The XML namespace the specifies this content.
      POCO_NAMESPACE = 'http://portablecontacts.net/spec/1.0'

      namespace POCO_NAMESPACE

      element :domain
      element :username
      element :userid

      def initialize(o = {})
        case o
        when XML::Reader
          o.read
          parse(o)
        when Hash
          o.each do |k, v|
            if k.to_s.include? '_'
              k = k.to_s.gsub(/_(.)/){"#{$1.upcase}"}.intern
            end
            self.send("#{k.to_s}=", v)
          end
        else
          raise ArgumentError, "Got #{o.class} but expected a Hash or XML::Reader"
        end

        yield(self) if block_given?
      end

      def to_hash
        {
          :domain => self.domain,
          :username => self.username,
          :userid => self.userid
        }
      end

      def to_canonical
        to_hash
      end
    end
  end
end
