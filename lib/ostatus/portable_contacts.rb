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

    def id;         get_prop(:id); end
    def name;       get_prop(:name); end
    def nickname;   get_prop(:nickname); end
    def gender;     get_prop(:gender); end
    def note;       get_prop(:note); end

    def display_name;       get_prop(:display_name, 'displayName'); end
    def preferred_username; get_prop(:preferred_username, 'preferredUsername'); end

    def updated;   get_datetime(:updated); end
    def published; get_datetime(:published); end

    def birthday;    get_date(:birthday); end
    def anniversary; get_date(:anniversary); end

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

  private

    def get_prop name, xmlName = name
      @options ? @options[name] : @parent.send("poco_#{xmlName}")
    end

    def get_datetime x
      if @options
        dt = @options[x]
        DateTime.parse(dt) if dt
      else
        @parent.send("poco_#{x}")
      end
    end

    def get_date x
      if @options
        d = @options[x]
        Date.parse(d) if d
      else
        @parent.send("poco_#{x}")
      end
    end

  end
end
