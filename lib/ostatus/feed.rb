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
    #                 published. Defaults: DateTime.now
    #   salmon_url => The url of the salmon endpoint, if one exists, for this
    #                 feed.
    def initialize(options = {})
      @id = options[:id]
      @url = options[:url]
      @title = options[:title] || "Untitled"
      @authors = options[:authors] || []
      @entries = options[:entries] || []
      @updated = options[:updated]
      @published = options[:published] || DateTime.now
    end

    def to_hash
      {
        :id => self.id,
        :url => self.url,
        :title => self.title,
        :authors => self.authors,
        :entries => self.entries,
        :updated => self.updated,
        :published => self.published
      }
    end
  end
end
