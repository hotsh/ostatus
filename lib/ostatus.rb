require 'ostatus/feed'
require 'ostatus/entry'
require 'ostatus/author'
require 'ostatus/activity'
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
  require 'net/http'

  # Will yield a OStatus::Feed object representing the feed at the given url.
  def self.feed_from_url(url, content_type = "application/atom+xml")
    # Atom is default type to attempt to retrieve
    content_type ||= "application/atom+xml"

    response = OStatus::pull_url(url, content_type)

    return nil unless response.is_a?(Net::HTTPSuccess)

    case response.content_type
    when 'application/atom+xml', 'application/rss+xml', 'application/xml'
      xml_str = response.body

      OStatus::Atom::Feed.new(XML::Reader.string(xml_str)).to_canonical
    when 'text/html'
      html_str = response.body

      # Discover the feed
      doc = LibXML::XML::HTMLParser.string(html_str).parse
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

  def self.pull_url(url, content_type = nil, limit = 10)
    # Atom is default type to attempt to retrieve
    content_type ||= "application/atom+xml"

    uri = URI(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.content_type = content_type

    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    response = http.request(request)
    puts response

    if response.is_a?(Net::HTTPRedirection) && limit > 0
      location = response['location']
      OStatus.pull_url(location, content_type, limit - 1)
    else
      response
    end
  end

  def self.entry_from_url(url, content_type = nil)
    # Atom is default type to attempt to retrieve
    content_type ||= "application/atom+xml"

    response = OStatus.pull_url(url, content_type)

    return nil unless response.is_a?(Net::HTTPSuccess)

    case response.content_type
    when 'application/atom+xml', 'application/rss+xml', 'application/xml'
      xml_str = response.body
      OStatus::Atom::Entry.new(XML::Reader.string(xml_str)).to_canonical
    when 'text/html'
      html_str = response.body

      # Discover the feed
      doc = LibXML::XML::HTMLParser.string(html_str).parse
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
