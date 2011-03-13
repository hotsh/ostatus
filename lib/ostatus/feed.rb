require 'nokogiri'
require 'open-uri'
require 'tinyatom'

require_relative 'entry'

module OStatus

  # This class represents an OStatus Feed object.
  class Feed
    def initialize(url, access_token, author, entries, id, title)
      @url = url
      @access_token = access_token
      @author = author
      @entries = entries
      @id = id
      @title = title

      if id == nil
        @xml = Nokogiri::XML::Document.parse(self.atom)
      end
    end

    # Creates a new Feed instance given by the atom feed located at 'url'
    # and optionally using the OAuth::AccessToken given.
    def Feed.from_url(url, access_token = nil)
      Feed.new(url, access_token, nil, nil, nil, nil)
    end

    # Creates a new Feed instance that contains the information given by
    # the various instances of author and entries.
    def Feed.from_data(id, title, url, author, entries)
      Feed.new(url, nil, author, entries, id, title)
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
      return @hub_url[:link][attribute] unless @hub_url == nil or @hub_url[:link] == nil

      # get all links with rel attribute being equal to attribute
      @xml.xpath('/xmlns:feed/xmlns:link').select do |link|
        link[:rel] == attribute.to_s
      end
    end

    # Returns an array of URLs for each hub link tag.
    def hubs
      link(:hub).map do |link|
        link[:href]
      end
    end

    # Returns the salmon URL from the link tag.
    def salmon
      link(:salmon).first[:href]
    end

    # This method will return a String containing the actual content of
    # the atom feed. It will make a network request (through OAuth if
    # an access token was given) to retrieve the document if necessary.
    def atom
      if @access_token == nil
        # simply open the url
        open(@url).read
      elsif @url != nil
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

        feed.add_entry
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
      return @id if @xml == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:id'))
    end

    def title
      return @title if @xml == nil

      pick_first_node(@xml.xpath('/xmlns:feed/xmlns:title'))
    end

    def url
      return @url
    end

    # Returns an OStatus::Author that will parse the author information
    # within the Feed.
    def author
      return @author if @xml == nil

      author_xml = @xml.at_css('author')
      OStatus::Author.new(author_xml)
    end

    # This method gives you an array of OStatus::Entry instances for 
    # each entry listed in the feed.
    def entries
      return @entries if @xml == nil

      entries_xml = @xml.css('entry')

      entries_xml.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
