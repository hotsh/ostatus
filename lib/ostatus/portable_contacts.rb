module OStatus
  POCO_NS = 'http://portablecontacts.net/spec/1.0'

  # Holds information about the extended contact information
  # in the Feed given in the Portable Contacts specification.
  class PortableContacts
    
    # Instantiates a OStatus::PortableContacts object from either
    # a given root that contains all <poco:*> tags as an ratom Person
    #  or a Hash containing the properties.
    def initialize(poco)
      @poco = poco
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    # Returns the id of the contact, if it exists.
    def id
      return @poco_data[:id] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:id'))
    end

    # Returns the display_name of the contact, if it exists.
    def display_name
      return @poco_data[:display_name] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:displayName'))
    end

    # Returns the name of the contact, if it exists.
    def name
      return @poco_data[:name] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:name'))
    end

    # Returns the nickname of the contact, if it exists.
    def nickname
      return @poco_data[:nickname] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:nickname'))
    end

    # Returns the published of the contact, if it exists.
    def published
      return @poco_data[:published] unless @poco_data == nil
      pub = pick_first_node(@poco.xpath('./poco:published'))
      if pub != nil
        DateTime.parse(pub)
      end
    end

    # Returns the updated of the contact, if it exists.
    def updated
      return @poco_data[:updated] unless @poco_data == nil
      upd = pick_first_node(@poco.xpath('./poco:updated'))
      if upd != nil
        DateTime.parse(upd)
      end
    end

    # Returns the birthday of the contact, if it exists.
    def birthday
      return @poco_data[:birthday] unless @poco_data == nil
      bday = pick_first_node(@poco.xpath('./poco:birthday'))
      if bday != nil
        Date.parse(bday)
      end
    end

    # Returns the anniversary of the contact, if it exists.
    def anniversary
      return @poco_data[:anniversary] unless @poco_data == nil
      anni = pick_first_node(@poco.xpath('./poco:anniversary'))
      if anni != nil
        Date.parse(anni)
      end
    end

    # Returns the gender of the contact, if it exists.
    def gender
      return @poco_data[:gender] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:gender'))
    end

    # Returns the note of the contact, if it exists.
    def note
      return @poco_data[:note] unless @poco_data == nil
      pick_first_node(@poco.xpath('./poco:note'))
    end

    # Returns the preferred username of the contact, if it exists.
    def preferred_username
      @poco[POCO_NS, 'preferredUsername'].first
    end

    # Returns a boolean that indicates that a bi-directional connection
    # has been established between the user and the contact, if it is
    # able to assert this.
    def connected
      str = @poco[POCO_NS, 'connected'].first

      if str == "true"
        true
      elsif str == "false"
        false
      else
        nil
      end
    end
  end
end
