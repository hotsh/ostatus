module OStatus

  # Holds information about the extended contact information
  # in the Feed given in the Portable Contacts specification.
  class PortableContacts
    
    # Instantiates a OStatus::ProtableContacts object from a
    # given root that contains all <poco:*> tags as a
    # Nokogiri::XML::Element
    def initialize(author_node)
      @poco = author_node
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
      pick_first_node(@poco.xpath('./poco:id'))
    end

    # Returns the display_name of the contact, if it exists.
    def display_name
      pick_first_node(@poco.xpath('./poco:displayName'))
    end

    # Returns the name of the contact, if it exists.
    def name
      pick_first_node(@poco.xpath('./poco:name'))
    end

    # Returns the nickname of the contact, if it exists.
    def nickname
      pick_first_node(@poco.xpath('./poco:nickname'))
    end

    # Returns the published of the contact, if it exists.
    def published
      pub = pick_first_node(@poco.xpath('./poco:published'))
      if pub != nil
        DateTime.parse(pub)
      end
    end

    # Returns the updated of the contact, if it exists.
    def updated
      upd = pick_first_node(@poco.xpath('./poco:updated'))
      if upd != nil
        DateTime.parse(upd)
      end
    end

    # Returns the birthday of the contact, if it exists.
    def birthday
      bday = pick_first_node(@poco.xpath('./poco:birthday'))
      if bday != nil
        Date.parse(bday)
      end
    end

    # Returns the anniversary of the contact, if it exists.
    def anniversary
      anni = pick_first_node(@poco.xpath('./poco:anniversary'))
      if anni != nil
        Date.parse(anni)
      end
    end

    # Returns the gender of the contact, if it exists.
    def gender
      pick_first_node(@poco.xpath('./poco:gender'))
    end

    # Returns the note of the contact, if it exists.
    def note
      pick_first_node(@poco.xpath('./poco:note'))
    end

    # Returns the preferred username of the contact, if it exists.
    def preferred_username
      pick_first_node(@poco.xpath('./poco:preferredUsername'))
    end

    # Returns a boolean that indicates that a bi-directional connection
    # has been established between the user and the contact, if it is
    # able to assert this.
    def connected
      str = pick_first_node(@poco.xpath('./poco:connected'))
      return nil if str == nil

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
