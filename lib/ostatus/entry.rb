require_relative 'activity'

module OStatus

  # Holds information about an individual entry in the Feed.
  class Entry

    # Instantiates an Entry object from a given <entry></entry> root
    # passed as an instance of a Nokogiri::XML::Element.
    def initialize(entry_node)
      @entry = entry_node
    end

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      Activity.new(@entry)
    end

    def to_s
      info.to_s
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    # Returns the title of the entry.
    def title
      pick_first_node(@entry.css('title'))
    end

    # Returns the content of the entry.
    def content
      pick_first_node(@entry.css('content'))
    end

    # Returns the content-type of the entry.
    def content_type
      content = @entry.css('content')
      content.empty? ? "" : content[0]['type']
    end

    # Returns the DateTime that this entry was published.
    def published
      DateTime.parse(pick_first_node(@entry.css('published')))
    end

    # Returns the DateTime that this entry was updated.
    def updated
      DateTime.parse(pick_first_node(@entry.css('updated')))
    end

    # Returns the id of the entry.
    def id
      pick_first_node(@entry.css('id'))
    end

    # Returns a Hash of all fields.
    def info
      {
        :activity => self.activity.info,
        :id => pick_first_node(@entry.css('id')),
        :title => self.title,
        :content => self.content,
        :content_type => self.content_type,
        :link => @entry.css('link'),
        :published => self.published,
        :updated => self.updated
      }
    end
  end
end
