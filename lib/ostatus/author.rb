require_relative 'activity'
require_relative 'portable_contacts'

module OStatus

  # Holds information about the author of the Feed.
  class Author

    # Instantiates an Author object either from a given <author></author> root
    # passed as an instance of an ratom Atom::Author or a Hash containing
    # the properties.
    def initialize(author)
      @author = author
    end

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      OStatus::Activity.new(@author)
    end

    # Returns the name of the author, if it exists.
    def name
      @author.name
    end

    # Returns the email of the author, if it exists.
    def email
      @author.email
    end

    # Returns the uri of the author, if it exists.
    def uri
      @author.uri
    end

    # Returns an instance of a PortableContacts that further describe the
    # author's contact information, if it exists.
    def portable_contacts
      return @author_data[:portable_contacts] unless @author_data == nil
      PortableContacts.new(@author)
    end
  end
end
