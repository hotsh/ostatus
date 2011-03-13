require 'nokogiri'
require 'open-uri'

require_relative 'entry'

module OStatus

  # This class represents an OStatus Feed object.
  class Feed

    # Creates a new Feed instance given by the atom feed located at 'url'
    # and optionally using the OAuth::AccessToken given.
    def initialize(url, access_token = nil)
      @url = url
      @access_token = access_token
    end

    # This method will return a String containing the actual content of
    # the atom feed. It will make a network request (through OAuth if
    # an access token was given) to retrieve the document if necessary.
    def atom
      if @access_token == nil
        open(@url).read
      else
        @access_token.get(@url).body
      end
    end

    # Returns an OStatus::Author that will parse the author information
    # within the Feed.
    def author
      xml = Nokogiri::XML::Document.parse(self.atom)

      author_xml = xml.at_css('author')
      OStatus::Author.new(author_xml)
    end

    # This method gives you an array of OStatus::Entry instances for 
    # each entry listed in the feed.
    def entries
      xml = Nokogiri::XML::Document.parse(self.atom)
      entries_xml = xml.css('entry')

      entries_xml.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
