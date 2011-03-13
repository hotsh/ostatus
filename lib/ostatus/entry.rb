require_relative 'activity'

module OStatus
  class Entry
    def initialize(entry_nodeset)
      @entry = entry_nodeset
    end

    def activity
      Activity.new(@entry.xpath('activity:*'))
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

    def title
      pick_first_node(@entry.css('title'))
    end

    def content
      pick_first_node(@entry.css('content'))
    end

    def content_type
      content = @entry.css('content')
      content_type = content[0]['type'] unless content.empty?
      content.empty? ? "" : content[0].content
    end

    def published
      Date.parse(pick_first_node(@entry.css('published')))
    end

    def updated
      Date.parse(pick_first_node(@entry.css('updated')))
    end

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
