require_relative 'activity'

module OStatus

  # Holds information about an individual entry in the Feed.
  class Entry

    # Instantiates an Entry object from either a given <entry></entry> root
    # passed as an instance of a Nokogiri::XML::Element or a Hash
    # containing the properties.
    def initialize(entry_node)
      if entry_node.class == Hash
        @entry_data = entry_node
        @entry = nil
      else
        @entry = entry_node
        @entry_data = nil
      end
    end

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      Activity.new(@entry)
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
      return @entry_data[:title] unless @entry_data == nil
      pick_first_node(@entry.css('title'))
    end

    # Returns the content of the entry.
    def content
      return @entry_data[:content] unless @entry_data == nil
      pick_first_node(@entry.css('content'))
    end

    # Returns the content-type of the entry.
    def content_type
      return @entry_data[:content_type] unless @entry_data == nil
      content = @entry.css('content')
      content.empty? ? "" : content[0]['type']
    end

    # Returns the DateTime that this entry was published.
    def published
      return @entry_data[:published] unless @entry_data == nil
      DateTime.parse(pick_first_node(@entry.css('published')))
    end

    # Returns the DateTime that this entry was updated.
    def updated
      return @entry_data[:updated] unless @entry_data == nil
      DateTime.parse(pick_first_node(@entry.css('updated')))
    end

    # Returns the id of the entry.
    def id
      return @entry_data[:id] unless @entry_data == nil
      pick_first_node(@entry.css('id'))
    end

    def url
      return @entry_data[:url] unless @entry_data == nil or @entry_data[:url] == nil
      return nil if @entry_data != nil

      cur_url = nil
      @entry.css('link').each do |node|
        if node[:href]
          cur_url = node[:href]
        end
      end

      if cur_url
        cur_url
      else
        links = self.link
        if links[:self]
          links[:self][:href]
        elsif links[:alternate]
          links[:altername][:href]
        end
      end
    end

    def link
      return @entry_data[:link] unless @entry_data == nil

      result = {}

      @entry.css('link').each do |node|
        if node[:rel] != nil
          rel = node[:rel].intern
          if result[rel] == nil
            result[rel] = []
          end

          result[rel] << node
        end
      end

      result
    end

    # Returns a Hash of all fields.
    def info
      return @entry_data unless @entry_data == nil
      {
        :activity => self.activity.info,
        :id => pick_first_node(@entry.css('id')),
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
