require 'ostatus/entry'
require 'ostatus/author'
require 'ostatus/category'
require 'ostatus/generator'
require 'ostatus/portable_contacts'

require 'ostatus/atom/entry'
require 'ostatus/atom/generator'
require 'ostatus/atom/category'
require 'ostatus/atom/author'
require 'ostatus/atom/link'

module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus Feed object.
    class Feed < ::Atom::Feed
      require 'open-uri'

      include ::Atom::SimpleExtensions

      namespace ::Atom::NAMESPACE

      add_extension_namespace :poco, PortableContacts::NAMESPACE
      add_extension_namespace :poco, Activity::NAMESPACE
      element :id, :rights, :icon, :logo
      element :generator, :class => OStatus::Atom::Generator
      element :title, :subtitle, :class => ::Atom::Content
      element :published, :class => Time, :content_only => true
      element :updated, :class => Time, :content_only => true
      elements :links, :class => ::Atom::Link
      elements :authors, :class => OStatus::Atom::Author
      elements :contributors, :class => OStatus::Atom::Author
      elements :categories, :class => OStatus::Atom::Category
      elements :entries, :class => OStatus::Atom::Entry

      attr_accessor :url

      # Store in reverse order so that the -1 from .index "not found"
      # will sort properly
      MIME_ORDER = ['application/atom+xml', 'application/rss+xml',
        'application/xml'].reverse

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

      def self.from_canonical(obj)
        hash = obj.to_hash
        hash[:entries].map! {|e|
          OStatus::Atom::Entry.from_canonical(e)
        }

        # Ensure that the generator is encoded.
        if hash[:generator]
          hash[:generator] = OStatus::Atom::Generator.from_canonical(hash[:generator])
        end

        hash[:links] ||= []

        if hash[:salmon_url]
          hash[:links] << ::Atom::Link.new(:rel => "salmon", :href => hash[:salmon_url])
        end
        hash.delete :salmon_url

        if hash[:url]
          hash[:links] << ::Atom::Link.new(:rel => "self", :href => hash[:url])
        end
        hash.delete :url

        hash[:authors].map! {|a|
          OStatus::Atom::Author.from_canonical(a)
        }

        hash[:contributors].map! {|a|
          OStatus::Atom::Author.from_canonical(a)
        }

        hash[:categories].map! {|c|
          OStatus::Atom::Category.from_canonical(c)
        }

        self.new(hash)
      end

      def to_canonical
        generator = nil
        generator = self.generator.to_canonical if self.generator

        salmon_url = nil
        if self.link('salmon').any?
          salmon_url = self.link('salmon').first.href
        end

        url = nil
        if self.link('self').any?
          url = self.link('self').first.href
        end

        categories = self.categories.map(&:to_canonical)

        OStatus::Feed.new(:title        => self.title,
                          :id           => self.id,
                          :url          => url,
                          :categories   => categories,
                          :icon         => self.icon,
                          :logo         => self.logo,
                          :rights       => self.rights,
                          :published    => self.published,
                          :updated      => self.updated,
                          :entries      => self.entries.map(&:to_canonical),
                          :authors      => self.authors.map(&:to_canonical),
                          :contributors => self.contributors.map(&:to_canonical),
                          :hubs         => self.hubs,
                          :salmon_url   => salmon_url,
                          :generator    => generator)
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

      # Returns an array of URLs for each hub link tag.
      def hubs
        link(:hub).map { |link| link.href }
      end

      # Returns a string of the url for this feed.
      def url
        if links.alternate
          links.alternate.href
        elsif links.self
          links.self.href
        else
          links.map.each do |l|
            l.href
          end.compact.first
        end
      end

      # Returns the salmon URL from the link tag.
      def salmon
        link(:salmon).first.href if link(:salmon)
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
end
