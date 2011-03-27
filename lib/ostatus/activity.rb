# it is unfortunate that ratom doesn't do this on its own.
class Atom::Person
  include Atom::SimpleExtensions
end

module OStatus
  ACTIVITY_NS = 'http://activitystrea.ms/spec/1.0/'

  # This class represents an Activity object for an OStatus entry.
  class Activity

    # This will create an instance of an Activity class populated
    # with the given data as a Hash or parsable XML given by a 
    # Nokogiri::XML::Element that serves as the root node of
    # anything containing the activity tags.
    def initialize(entry)
      @entry = entry
    end

    # Returns the object field or nil if it does not exist.
    def object
      @entry[ACTIVITY_NS, 'object'].first
    end

    # Returns the target field or nil if it does not exist.
    def target
      @entry[ACTIVITY_NS, 'target'].first
    end

    # Returns the verb field or nil if it does not exist.
    def verb
      @entry[ACTIVITY_NS, 'verb'].first
    end

    # Returns the object-type field or nil if it does not exist.
    def object_type
      @entry[ACTIVITY_NS, 'object-type'].first
    end

    # Returns a hash of all relevant fields.
    def info
      {
        :object => self.object,
        :target => self.target,
        :verb => self.verb,
        :object_type => self.object_type
      }
    end
  end
end
