require 'ostatus/activity'
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

    # Holds the list of categories for this feed as OStatus::Category.
    attr_reader :categories

    # Holds human-readable information about the content rights of the entries
    # in the feed without an explicit rights field of their own. SHOULD NOT be
    # machine interpreted.
    attr_reader :rights

    # Holds the title for this feed.
    attr_reader :title

    # Holds the content-type for the title.
    attr_reader :title_type

    # Holds the subtitle for this feed.
    attr_reader :subtitle

    # Holds the content-type for the subtitle.
    attr_reader :subtitle_type

    # Holds the URL for the icon representing this feed.
    attr_reader :icon

    # Holds the URL for the logo representing this feed.
    attr_reader :logo

    # Holds the generator for this content as an OStatus::Generator.
    attr_reader :generator

    # Holds the list of contributors, if any, that are involved in this feed
    # as OStatus::Author.
    attr_reader :contributors

    # Holds the DateTime when this feed was originally created.
    attr_reader :published

    # Holds the DateTime when this feed was last modified.
    attr_reader :updated

    # Holds the list of authors as OStatus::Author responsible for this feed.
    attr_reader :authors

    # Holds the list of entries as OStatus::Activity contained within this feed.
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
    #   id            => The unique identifier for this feed.
    #   url           => The url that represents this feed.
    #   title         => The title for this feed. Defaults: "Untitled"
    #   title_type    => The content type for the title.
    #   subtitle      => The subtitle for this feed.
    #   subtitle_type => The content type for the subtitle.
    #   authors       => The list of OStatus::Author's for this feed.
    #                    Defaults: []
    #   contributors  => The list of OStatus::Author's that contributed to this
    #                    feed. Defaults: []
    #   entries       => The list of OStatus::Activity's for this feed.
    #                    Defaults: []
    #   icon          => The url of the icon that represents this feed. It
    #                    should have an aspect ratio of 1 horizontal to 1
    #                    vertical and optimized for presentation at a
    #                    small size.
    #   logo          => The url of the logo that represents this feed. It
    #                    should have an aspect ratio of 2 horizontal to 1
    #                    vertical.
    #   categories    => An array of OStatus::Category's that describe how to
    #                    categorize and describe the content of the feed.
    #                    Defaults: []
    #   rights        => A String depicting the rights of entries without
    #                    explicit rights of their own. SHOULD NOT be machine
    #                    interpreted.
    #   updated       => The DateTime representing when this feed was last
    #                    modified.
    #   published     => The DateTime representing when this feed was originally
    #                    published.
    #   salmon_url    => The url of the salmon endpoint, if one exists, for this
    #                    feed.
    #   links         => An array of OStatus::Link that adds relations to other
    #                    resources.
    #   generator     => An OStatus::Generator representing the agent
    #                    responsible for generating this feed.
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
      @icon = options[:icon]
      @logo = options[:logo]
      @rights = options[:rights]
      @title = options[:title] || "Untitled"
      @title_type = options[:title_type]
      @subtitle = options[:subtitle]
      @subtitle_type = options[:subtitle_type]
      @authors = options[:authors] || []
      @categories = options[:categories] || []
      @contributors = options[:contributors] || []
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
        :hubs => self.hubs.dup,
        :icon => self.icon,
        :logo => self.logo,
        :rights => self.rights,
        :title => self.title,
        :title_type => self.title_type,
        :subtitle => self.subtitle,
        :subtitle_type => self.subtitle_type,
        :authors => self.authors.dup,
        :categories => self.categories.dup,
        :contributors => self.contributors.dup,
        :entries => self.entries.dup,
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
