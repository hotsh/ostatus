require 'nokogiri'
require 'open-uri'
require 'tinyatom'
require 'atom'

require_relative 'entry'
require_relative 'author'

module OStatus

  # This class represents an OStatus Feed object.
  class Feed
    def initialize(str, url, access_token, options)
      @str = str
      @url = url
      @access_token = access_token
      @options = options

      if options.nil?
        @f = Atom::Feed.load_feed(self.atom)
      end
    end

    # Creates a new Feed instance given by the atom feed located at 'url'
    # and optionally using the OAuth::AccessToken given.
    def Feed.from_url(url, access_token = nil)
      Feed.new(nil, url, access_token, nil)
    end

    # Creates a new Feed instance that contains the information given by
    # the various instances of author and entries.
    def Feed.from_data(url, options)
      Feed.new(nil, url, nil, options)
    end

    def Feed.from_string(str)
      Feed.new(str, nil, nil, nil)
    end

    # Returns an array of  Nokogiri::XML::Element instances for all link tags
    # that have a rel equal to that given by attribute. This can be used 
    # generally as a Hash where the keys are intern strings that give an attribute.
    #
    # For example:
    #   link(:hub).first[:href] -- Gets the first link tag with rel="hub" and
    #                              returns the contents of the href attribute.
    #
    def link(attribute)
      @f.links.find_all { |l| l.rel == attribute.to_s }
    end

    # Returns an array of URLs for each hub link tag.
    def hubs
      link(:hub).map do |link|
        link.href
      end
    end

    # Returns the salmon URL from the link tag.
    def salmon
      link(:salmon).first.href
    end

    # Returns the logo
    def logo
      return @options[:logo] unless @options == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:logo'))
    end

    # Returns the icon
    def icon
      return @options[:icon] unless @options == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:icon'))
    end

    # This method will return a String containing the actual content of
    # the atom feed. It will make a network request (through OAuth if
    # an access token was given) to retrieve the document if necessary.
    def atom
      if @str != nil
        @str
      elsif @options == nil and @access_token == nil
        # simply open the url
        open(@url).read
      elsif @options == nil and @url != nil
        # open the url through OAuth
        @access_token.get(@url).body
      else
        # build the atom file from internal information
        feed = TinyAtom::Feed.new(
          self.id,
          self.title,

          @url,

          :author_name => self.author.name,
          :author_email => self.author.email,
          :author_uri => self.author.uri,

          :hubs => self.hubs
        )

        @options[:entries].each do |entry|
          entry_url = entry.url
          entry_url = @url if entry_url == nil

          feed.add_entry(
            entry.id,
            entry.title,
            entry.updated,

            entry_url,

            :published => entry.published,

            :content => entry.content,

            :author_name => self.author.name,
            :author_email => self.author.email,
            :author_uri => self.author.uri
          )
        end

        feed.make(:indent => 2)
      end
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    def id
      return @options[:id] unless @options == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:id'))
    end

    def title
      return @options[:title] unless @options == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:title'))
    end

    def url
      return @url
    end

    # Returns an OStatus::Author that will parse the author information
    # within the Feed.
    def author
      return @options[:author] unless @options == nil

      author_xml = @xml.at_css('author')
      OStatus::Author.new(author_xml)
    end

    # This method gives you an array of OStatus::Entry instances for 
    # each entry listed in the feed.
    def entries
      @f.entries.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
