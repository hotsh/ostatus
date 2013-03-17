require 'ostatus/entry'
require 'ostatus/author'

module OStatus
  require 'atom'

  # This class represents an OStatus Feed object.
  class Feed
    require 'open-uri'
    require 'date'

    # Holds the id that uniquely represents this feed.
    attr_reader :id

    # Holds the url that represents this feed.
    attr_reader :url

    # Holds the title for this feed.
    attr_reader :title

    # Holds the hash identifying the agent responsible for this feed.
    #
    # contains one or more of the following:
    #   :name    => The human-readable name of the generator.
    #   :uri     => A URL that represents the generator that, when
    #               dereferenced, is related to that agent.
    #   :version => The version of the generating agent.
    attr_reader :generator

    # Holds the DateTime when this feed was originally created.
    attr_reader :published

    # Holds the DateTime when this feed was last modified.
    attr_reader :updated

    # Holds the list of authors as OStatus::Author responsible for this feed.
    attr_reader :authors

    # Holds the list of entries as OStatus::Entry contained within this feed.
    attr_reader :entries

    # Holds the list of hubs that are available to manage subscriptions to this
    # feed.
    attr_reader :hubs

    # Holds the salmon url that handles notifications for this feed.
    attr_reader :salmon_url

    # Holds links to other resources as an array of OStatus::Link
    attr_reader :links

    # Creates a new representation of a feed.
    #
    # options:
    #   id         => The unique identifier for this feed.
    #   url        => The url that represents this feed.
    #   title      => The title for this feed. Defaults: "Untitled"
    #   authors    => The list of OStatus::Author's for this feed. Defaults: []
    #   entries    => The list of OStatus::Entry's for this feed. Defaults: []
    #   updated    => The DateTime representing when this feed was last
    #                 modified.
    #   published  => The DateTime representing when this feed was originally
    #                 published.
    #   salmon_url => The url of the salmon endpoint, if one exists, for this
    #                 feed.
    #   links      => An array of OStatus::Link that adds relations to other
    #                 resources.
    #   generator  => A Hash representing the agent responsible for generating
    #                 this feed.
    #
    # Usage:
    #
    #   author = OStatus::Author.new(:name => "Kelly")
    #
    #   feed = OStatus::Feed.new(:title   => "My Feed",
    #                            :id      => "1",
    #                            :url     => "http://example.com/feeds/1",
    #                            :authors => [author])
    def initialize(options = {})
      @id = options[:id]
      @url = options[:url]
      @title = options[:title] || "Untitled"
      @authors = options[:authors] || []
      @entries = options[:entries] || []
      @updated = options[:updated]
      @published = options[:published]
      @salmon_url = options[:salmon_url]
      @hubs = options[:hubs] || []
      @generator = options[:generator]
    end

    # Yields a OStatus::Link to this feed.
    #
    # options: Can override OStatus::Link properties, such as rel.
    #
    # Usage:
    #
    #   feed = OStatus::Feed.new(:title => "Foo", :url => "http://example.com")
    #   feed.to_link(:rel => "alternate", :title => "Foo's Feed")
    #
    # Generates a link with:
    #   <OStatus::Link rel="alternate" title="Foo's Feed" url="http://example.com">
    def to_link(options = {})
      options = { :title => self.title,
                  :href  => self.url }.merge(options)

      OStatus::Link.new(options)
    end

    # Returns a hash of the properties of the feed.
    def to_hash
      {
        :id => self.id,
        :url => self.url,
        :title => self.title,
        :authors => self.authors,
        :entries => self.entries,
        :updated => self.updated,
        :salmon_url => self.salmon_url,
        :published => self.published,
        :generator => self.generator
      }
    end

    # Returns a string containing an Atom representation of the feed.
    def to_atom
      require 'ostatus/atom/feed'

      OStatus::Atom::Feed.from_canonical(self).to_xml
    end
  end
end
