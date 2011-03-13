require_relative 'activity'
require_relative 'portable_contacts'

module OStatus

  # Holds information about the author of the Feed.
  class Author

    # Instantiates an Author object either from a given <author></author> root
    # passed as an instance of a Nokogiri::XML::Element or a Hash containing
    # the properties.
    def initialize(author_node)
      if author_node.class == Hash
        @author_data = author_node
        @author = nil
      else
        @author = author_node
        @author_data = nil
      end
    end

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      OStatus::Activity.new(@author)
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    # Returns the name of the author, if it exists.
    def name
      return @author_data[:name] unless @author_data == nil
      pick_first_node(@author.css('name'))
    end

    # Returns the email of the author, if it exists.
    def email
      return @author_data[:email] unless @author_data == nil
      pick_first_node(@author.css('email'))
    end

    # Returns the uri of the author, if it exists.
    def uri
      return @author_data[:uri] unless @author_data == nil
      pick_first_node(@author.css('uri'))
    end

    # Returns an instance of a PortableContacts that further describe the
    # author's contact information, if it exists.
    def portable_contacts
      return @author_data[:portable_contacts] unless @author_data == nil
      PortableContacts.new(@author)
    end
  end
end
