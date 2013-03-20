module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus PortableContacts Organization object.
    class Organization
      include ::Atom::Xml::Parseable

      namespace OStatus::Author::NAMESPACE

      element :name
      element :department
      element :title
      element :type
      element :startDate, :class => Date, :content_only => true
      element :endDate,   :class => Date, :content_only => true
      element :location
      element :description

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
          :name => self.name,
          :department => self.department,
          :title => self.title,
          :type => self.type,
          :start_date => self.startDate,
          :end_date => self.endDate,
          :location => self.location,
          :description => self.description
        }
      end

      def to_canonical
        to_hash
      end
    end
  end
end


