require_relative 'activity'

module OStatus

  # Holds information about the author of the Feed.
  class Author

    # Instantiates an Author object from a given <author></author> root
    # passed as an instance of a Nokogiri::XML::Element.
    def initialize(author_node)
      @author = author_node
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

    def name
      pick_first_node(@author.css('name'))
    end

    def email
      pick_first_node(@author.css('email'))
    end

    def uri
      pick_first_node(@author.css('uri'))
    end
  end
end
