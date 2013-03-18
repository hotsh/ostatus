module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus PortableContacts Address object.
    class Address
      include ::Atom::Xml::Parseable

      namespace OStatus::PortableContacts::NAMESPACE

      element :formatted
      element :streetAddress
      element :locality
      element :region
      element :postalCode
      element :country

      def initialize(o = {})
        case o
        when XML::Reader
          o.read
          parse(o, :test=>true)
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
          :street_address => self.streetAddress,
          :locality => self.locality,
          :region => self.region,
          :postal_code => self.postalCode,
          :country => self.country
        }
      end

      def to_canonical
        to_hash
      end
    end
  end
end
