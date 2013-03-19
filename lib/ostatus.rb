require 'ostatus/feed'
require 'ostatus/entry'
require 'ostatus/author'
require 'ostatus/activity'
require 'ostatus/portable_contacts'
require 'ostatus/salmon'
require 'ostatus/link'

# This module contains individual elements of the OStatus protocol. It also
# contains methods to construct these objects from external sources.
module OStatus
  require 'libxml'

  # This module isolates Atom generation.
  module Atom
  end

  require 'ostatus/atom/feed'

  # Will yield a OStatus::Feed object representing the feed at the given url.
  def self.feed_from_url(url, content_type = "application/atom+xml")
    case content_type
    when 'application/atom+xml', 'application/rss+xml', 'application/xml'
      str = open(url).read

      OStatus::Atom::Feed.new(XML::Reader.string(str)).to_canonical
    when 'text/html'
      str = open(url)

      # Discover the feed
      doc = LibXML::XML::HTMLParser.string(str).parse
      links = doc.find(
        "//*[contains(concat(' ',normalize-space(@rel),' '), 'alternate')]"
      ).map {|el|
        {:type => el.attributes['type'].to_s,
          :href => el.attributes['href'].to_s}
      }.sort {|a, b|
        MIME_ORDER.index(b[:type]) || -1 <=>
        MIME_ORDER.index(a[:type]) || -1
      }

      # Resolve relative links
      link = URI::parse(links.first[:href]) rescue URI.new

      unless link.host
        link.host = URI::parse(@url).host rescue nil
      end

      unless link.absolute?
        link.path = File::dirname(URI::parse(@url).path) \
          + '/' + link.path rescue nil
      end

      url = link.to_s
      from_feed_url(url)
    end
  end
end
