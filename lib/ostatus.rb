require 'ostatus/feed'
require 'ostatus/author'
require 'ostatus/activity'
require 'ostatus/identity'
require 'ostatus/notification'
require 'ostatus/link'

# This module contains individual elements of the OStatus protocol. It also
# contains methods to construct these objects from external sources.
module OStatus
  require 'libxml'

  # This module isolates Atom generation.
  module Atom; end

  require 'ostatus/atom/feed'
  require 'net/http'
  require 'redfinger'

  # The order to respect atom links
  MIME_ORDER = ['application/atom+xml',
                'application/rss+xml',
                'application/xml']

  # Will yield an OStatus::Identity for the given fully qualified name
  # (i.e. "user@domain.tld")
  def self.discover_user(name)
    xrd = Redfinger.finger(name)

    # magic-envelope public key
    public_key = find_link(xrd, 'magic-public-key')
    public_key = public_key.split(",")[1] || ""

    # ostatus notification endpoint
    salmon_url = find_link(xrd, 'salmon')

    # pump.io authentication endpoint
    dialback_url = find_link(xrd, 'dialback')

    # pump.io activity endpoints
    activity_inbox_endpoint = find_link(xrd, 'activity-inbox')
    activity_outbox_endpoint = find_link(xrd, 'activity-outbox')

    # profile page
    profile_page = find_link(xrd, 'http://webfinger.net/rel/profile-page')

    Identity.new(:public_key        => public_key,
                 :profile_page      => profile_page,
                 :salmon_endpoint   => salmon_url,
                 :dialback_endpoint => dialback_url,
                 :activity_inbox_endpoint => activity_inbox_endpoint,
                 :activity_outbox_endpoint => activity_outbox_endpoint)
  end

  # Will yield an OStatus::Author for the given person.
  #
  # identity: Can be a String containing a fully qualified name (i.e.
  # "user@domain.tld") or a previously resolved OStatus::Identity.
  def self.discover_author(identity)
    if identity.is_a? String
      identity = self.discover_user(identity)
    end

    return nil if identity.nil? || identity.profile_page.nil?

    # Discover Author information

    # Pull profile page
    # Look for a feed to pull
    feed = self.discover_feed(identity.profile_page)
    feed.authors.first
  end

  # Will yield a OStatus::Feed object representing the feed at the given url
  # or identity.
  #
  # Usage:
  #   feed = OStatus.discover_feed("https://rstat.us/users/wilkieii/feed")
  #
  #   i = OStatus.discover_user("wilkieii@rstat.us")
  #   feed = OStatus.discover_feed(i)
  def self.discover_feed(url_or_identity, content_type = "application/atom+xml")
    if url_or_identity.is_a? OStatus::Identity
      return self.discover_feed(url_or_identity.profile_page)
    end

    url = url_or_identity

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
      doc = Nokogiri::HTML::Document.parse(html_str)
      links = doc.xpath("//link[@rel='alternate']").map {|el|
        {:type => el.attributes['type'].to_s,
         :href => el.attributes['href'].to_s}
      }.select{|e|
        MIME_ORDER.include? e[:type]
      }.sort {|a, b|
        MIME_ORDER.index(a[:type]) <=>
        MIME_ORDER.index(b[:type])
      }

      return nil if links.empty?

      # Resolve relative links
      link = URI::parse(links.first[:href]) rescue URI.new

      unless link.scheme
        link.scheme = URI::parse(url).scheme
      end

      unless link.host
        link.host = URI::parse(url).host rescue nil
      end

      unless link.absolute?
        link.path = File::dirname(URI::parse(url).path) \
          + '/' + link.path rescue nil
      end

      url = link.to_s
      self.discover_feed(url, links.first[:type])
    end
  end

  # Yield an OStatus::Entry from the given url.
  def self.entry_from_url(url, content_type = nil)
    # Atom is default type to attempt to retrieve
    content_type ||= "application/atom+xml"

    response = OStatus.pull_url(url, content_type)

    return nil unless response.is_a?(Net::HTTPSuccess)

    case response.content_type
    when 'application/atom+xml', 'application/rss+xml', 'application/xml'
      xml_str = response.body
      OStatus::Atom::Entry.new(XML::Reader.string(xml_str)).to_canonical
    end
  end

  private

  # :nodoc:
  def self.pull_url(url, content_type = nil, limit = 10)
    # Atom is default type to attempt to retrieve
    content_type ||= "application/atom+xml"

    uri = URI(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.content_type = content_type

    http = Net::HTTP.new(uri.hostname, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    response = http.request(request)

    if response.is_a?(Net::HTTPRedirection) && limit > 0
      location = response['location']
      OStatus.pull_url(location, content_type, limit - 1)
    else
      response
    end
  end

  # :nodoc:
  def self.find_link(xrd, rel)
    link = xrd.links.find {|l| l['rel'].downcase == rel} || {}
    link.fetch("href") { nil }
  end
end
