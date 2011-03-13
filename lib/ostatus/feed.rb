require 'nokogiri'

require_relative 'entry'

module OStatus
  class Feed
    def initialize(access_token, url)
      @url = url
      @access_token = access_token
    end

    def retrieve_atom
      @access_token.get(@url)
    end

    def author
    end

    def entries
      atom = retrieve_atom()
      xml = Nokogiri::XML::Document.parse(atom.body)
      entries_xml = xml.css('entry')

      entries_xml.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
