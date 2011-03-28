module OStatus
  POCO_NS = 'http://portablecontacts.net/spec/1.0'

  # Holds information about the extended contact information
  # in the Feed given in the Portable Contacts specification.
  class PortableContacts
    
    # Instantiates a OStatus::PortableContacts object from either
    # a given root that contains all <poco:*> tags as an ratom Person
    #  or a Hash containing the properties.
    def initialize(parent)
      if parent.is_a? Hash
        @options = parent
      else
        @parent = parent
      end
    end

    # Returns the id of the contact, if it exists.
    def id
      return @options[:id] unless @options.nil?
      @parent.poco_id
    end

    # Returns the display_name of the contact, if it exists.
    def display_name
      return @options[:display_name] unless @options.nil?
      @parent.poco_displayName
    end

    # Returns the name of the contact, if it exists.
    def name
      return @options[:name] unless @options.nil?
      @parent.poco_name
    end

    # Returns the nickname of the contact, if it exists.
    def nickname
      return @options[:nick_name] unless @options.nil?
      @parent.poco_nickname
    end

    # Returns the published of the contact, if it exists.
    def published
      if @options.nil?
        @parent.poco_published
      else
        date = @options[:published]
        unless date.nil?
          DateTime.parse(date)
        end
      end
    end

    # Returns the updated of the contact, if it exists.
    def updated
      if @options.nil?
        @parent.poco_updated
      else
        date = @options[:updated]
        unless date.nil?
          DateTime.parse(date)
        end
      end
    end

    # Returns the birthday of the contact, if it exists.
    def birthday
      if @options.nil?
        @parent.poco_birthday
      else
        date = @options[:birthday]
        unless date.nil?
          Date.parse(date)
        end
      end
    end

    # Returns the anniversary of the contact, if it exists.
    def anniversary
      if @options.nil?
        @parent.poco_anniversary
      else
        date = @options[:anniversary]
        unless date.nil?
          Date.parse(date)
        end
      end
    end

    # Returns the gender of the contact, if it exists.
    def gender
      return @options[:gender] unless @options.nil?
      @parent.poco_gender
    end

    # Returns the note of the contact, if it exists.
    def note
      return @options[:note] unless @options.nil?
      @parent.poco_note
    end

    # Returns the preferred username of the contact, if it exists.
    def preferred_username
      return @options[:preferred_username] unless @options.nil?
      @parent.poco_preferredUsername
    end

    # Returns a boolean that indicates that a bi-directional connection
    # has been established between the user and the contact, if it is
    # able to assert this.
    def connected
      return @options[:connected] unless @options.nil?
      str = @parent.poco_connected

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
