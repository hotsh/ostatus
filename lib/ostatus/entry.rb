require_relative 'activity'

module OStatus

  # Holds information about an individual entry in the Feed.
  class Entry

    # Instantiates an Entry object from either a given <entry></entry> root
    # passed as an instance of an ratom Atom::Entry or a Hash
    # containing the properties.
    def initialize(entry_node)
      @entry = entry_node
    end

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      Activity.new(@entry)
    end

    # Returns the title of the entry.
    def title
      @entry.title
    end

    # Returns the content of the entry.
    def content
      @entry.content
    end

    # Returns the content-type of the entry.
    def content_type
      @entry.content.type
    end

    # Returns the DateTime that this entry was published.
    def published
      DateTime.parse(@entry.published.to_s)
    end

    # Returns the DateTime that this entry was updated.
    def updated
      DateTime.parse(@entry.updated.to_s)
    end

    # Returns the id of the entry.
    def id
      @entry.id
    end

    def url
      links = self.link
      if @entry.links.alternate
        @entry.links.alternate.href
      elsif @entry.links.self
        @enry.links.self.first
      else
        @entry.map.each do |l|
          l.href
        end.compact.first
      end
    end

    def link
      result = {}

      @entry.links.each do |l|
        if l.rel
          rel = l.rel.intern
          result[rel] ||= []
          result[rel] << l
        end
      end

      result
    end

    # Returns a Hash of all fields.
    def info
      return @entry_data unless @entry_data == nil
      {
        :activity => self.activity.info,
        :id => self.id,
        :title => self.title,
        :content => self.content,
        :content_type => self.content_type,
        :link => self.link,
        :published => self.published,
        :updated => self.updated
      }
    end
  end
end
