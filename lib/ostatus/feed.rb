require 'open-uri'
require 'atom'

require_relative 'entry'
require_relative 'author'

module OStatus

  # This class represents an OStatus Feed object.
  class Feed < ::Atom::Feed
    include ::Atom::SimpleExtensions

    namespace ::Atom::NAMESPACE

    add_extension_namespace :poco, POCO_NS
    add_extension_namespace :poco, Activity::NAMESPACE
    element :id, :rights, :icon, :logo
    element :generator, :class => ::Atom::Generator
    element :title, :subtitle, :class => ::Atom::Content
    element :updated, :class => Time, :content_only => true
    elements :links, :class => ::Atom::Link
    elements :authors, :class => OStatus::Author
    elements :categories, :class => ::Atom::Category
    elements :entries, :class => OStatus::Entry

    attr_reader :url

    # Store in reverse order so that the -1 from .index "not found"
    # will sort properly
    MIME_ORDER = ['application/atom+xml', 'application/rss+xml',
                  'application/xml'].reverse

    def initialize(str, url, access_token, options)
      @str = str
      @url = url
      @access_token = access_token
      @options = options

      if str

        if str =~ /<html/
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

          @url = link.to_s
          @str = str = open(@url).read
        end

        super(XML::Reader.string(str))
      else
        super(options)
      end
    end

    # Creates a new Feed instance given by the atom feed located at 'url'
    # and optionally using the OAuth::AccessToken given.
    def Feed.from_url(url, access_token = nil)
      if access_token.nil?
        # simply open the url
        str = open(url).read
      else
        # open the url through OAuth
        str = access_token.get(url).body
      end

      Feed.new(str, url, access_token, nil)
    end

    # Creates a new Feed instance that contains the information given by
    # the various instances of author and entries.
    def Feed.from_data(url, options)
      Feed.new(nil, url, nil, options)
    end

    def Feed.from_string(str)
      Feed.new(str, nil, nil, nil)
    end

    # Returns an array of ::Atom::Link instances for all link tags
    # that have a rel equal to that given by attribute.
    #
    # For example:
    #   link(:hub).first.href -- Gets the first link tag with rel="hub" and
    #                            returns the contents of the href attribute.
    #
    def link(attribute)
      links.find_all { |l| l.rel == attribute.to_s }
    end

    def links=(given)
      self.links.clear
      given.each do |rel,links|
        links.each do |l|
          self.links << ::Atom::Link.new(l.merge({:rel => rel}))
        end
      end
    end

    # Returns an array of URLs for each hub link tag.
    def hubs
      link(:hub).map { |link| link.href }
    end

    # Returns the salmon URL from the link tag.
    def salmon
      link(:salmon).first.href
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
        self.links << ::Atom::Link.new(:rel => 'self', :href => @url) if @url
        self.links << ::Atom::Link.new(:rel => 'edit', :href => @url) if @url
        self.to_xml
      end
    end

    # Returns an OStatus::Author that will parse the author information
    # within the Feed.
    def author
      @options ? @options[:author] : self.authors.first
    end

    def author= author
      self.authors.clear << author
    end

    def hubs= hubs
      hubs.each do |hub|
        links << ::Atom::Link.new(:rel => 'hub', :href => hub)
      end
    end
  end
end
