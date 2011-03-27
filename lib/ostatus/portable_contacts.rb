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

    # Returns the id of the contact, if it exists.
    def id
      @poco[POCO_NS, 'id'].first
    end

    # Returns the display_name of the contact, if it exists.
    def display_name
      @poco[POCO_NS, 'displayName'].first
    end

    # Returns the name of the contact, if it exists.
    def name
      @poco[POCO_NS, 'name'].first
    end

    # Returns the nickname of the contact, if it exists.
    def nickname
      @poco[POCO_NS, 'nickname'].first
    end

    # Returns the published of the contact, if it exists.
    def published
      date = @poco[POCO_NS, 'published'].first
      unless date.nil?
        DateTime.parse(date)
      end
    end

    # Returns the updated of the contact, if it exists.
    def updated
      date = @poco[POCO_NS, 'updated'].first
      unless date.nil?
        DateTime.parse(date)
      end
    end

    # Returns the birthday of the contact, if it exists.
    def birthday
      date = @poco[POCO_NS, 'birthday'].first
      unless date.nil?
        Date.parse(date)
      end
    end

    # Returns the anniversary of the contact, if it exists.
    def anniversary
      date = @poco[POCO_NS, 'anniversary'].first
      unless date.nil?
        Date.parse(date)
      end
    end

    # Returns the gender of the contact, if it exists.
    def gender
      @poco[POCO_NS, 'gender'].first
    end

    # Returns the note of the contact, if it exists.
    def note
      @poco[POCO_NS, 'note'].first
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
