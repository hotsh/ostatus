module OStatus

  # This class represents an Activity object for an OStatus entry.
  class Activity

    # This will create an instance of an Activity class populated
    # with the given data as a Hash or parsable XML given by a 
    # Nokogiri::XML::Element that serves as the root node of
    # anything containing the activity tags.
    def initialize(activity_root)
      if activity_root.class == Hash
        @activity_data = activity_root
        @activity = nil
      else
        @activity = activity_root
        @activity_data = nil
      end
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    # Returns the object field or nil if it does not exist.
    def object
      return @activity_data[:object] unless @activity_data == nil
      pick_first_node(@activity.xpath('./activity:object'))
    end

    # Returns the target field or nil if it does not exist.
    def target
      return @activity_data[:target] unless @activity_data == nil
      pick_first_node(@activity.xpath('./activity:target'))
    end

    # Returns the verb field or nil if it does not exist.
    def verb
      return @activity_data[:verb] unless @activity_data == nil
      pick_first_node(@activity.xpath('./activity:verb'))
    end

    # Returns the object-type field or nil if it does not exist.
    def object_type
      return @activity_data[:object_type] unless @activity_data == nil
      pick_first_node(@activity.xpath('./activity:object-type'))
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
