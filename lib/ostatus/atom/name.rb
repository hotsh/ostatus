module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus PortableContacts Name object.
    class Name
      include ::Atom::Xml::Parseable

      namespace OStatus::Author::NAMESPACE

      element :formatted
      element :familyName
      element :givenName
      element :middleName
      element :honorificPrefix
      element :honorificSuffix

      def initialize(o = {})
        case o
        when XML::Reader
          parse(o, :test => true)
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
          :formatted => self.formatted,
          :family_name => self.familyName,
          :given_name => self.givenName,
          :middle_name => self.middleName,
          :honorific_prefix => self.honorificPrefix,
          :honorific_suffix => self.honorificSuffix
        }
      end

      def to_canonical
        to_hash
      end
    end
  end
end


