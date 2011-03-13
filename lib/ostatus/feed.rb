require 'nokogiri'
require 'open-uri'

require_relative 'entry'

module OStatus
  class Feed
    def initialize(url, access_token = nil)
      @url = url
      @access_token = access_token
    end

    def atom
      if @access_token == nil
        open(@url).read
      else
        @access_token.get(@url).body
      end
    end

    def author
    end

    def entries
      xml = Nokogiri::XML::Document.parse(self.atom)
      entries_xml = xml.css('entry')

      entries_xml.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
