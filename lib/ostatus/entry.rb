require 'ostatus/activity'
require 'ostatus/author'
require 'ostatus/thread'
require 'ostatus/link'

module OStatus
  # Holds information about an individual entry in the Feed.
  class Entry
    # Holds a String containing the title of the entry.
    attr_reader :title

    # Holds an OStatus::Author.
    attr_reader :author

    # Holds the content.
    attr_reader :content

    # Holds the MIME type of the content.
    attr_reader :content_type

    # Holds the id that uniquely identifies this entry.
    attr_reader :id

    # Holds the url that represents the entry.
    attr_reader :url

    # Holds the DateTime of when the entry was published originally.
    attr_reader :published

    # Holds the DateTime of when the entry was last modified.
    attr_reader :updated

    # Holds the OStatus::Activity associated with this entry.
    attr_reader :activity

    # Holds an array of related resources that this entry is a response to.
    attr_reader :in_reply_to

    # Create a new entry with the given content.
    #
    # options:
    #   :title        => The title of the entry. Defaults: "Untitled"
    #   :author       => A OStatus::Author responsible for generating this entry.
    #   :content      => The content of the entry. Defaults: ""
    #   :content_type => The MIME type of the content.
    #   :published    => The DateTime depicting when the entry was originally
    #                    published.
    #   :updated      => The DateTime depicting when the entry was modified.
    #   :url          => The canonical url of the entry.
    #   :id           => The unique id that identifies this entry.
    #   :activity     => The activity this entry represents. Either a single string
    #                    denoting what type of object this entry represents, or an
    #                    entire OStatus::Activity when a more detailed description is
    #                    appropriate.
    #   :in_reply_to  => An array of OStatus::Thread that this entry is a
    #                    response to. Use this when this Entry is a reply
    #                    to an existing Entry.
    def initialize(options = {})
      @title        = options[:title] || "Untitled"
      @author       = options[:author]
      @content      = options[:content] || ""
      @content_type = options[:content_type]
      @published    = options[:published]
      @updated      = options[:updated]
      @url          = options[:url]
      @id           = options[:id]
      if options[:activity].is_a? String
        @activity = OStatus::Activity.new(:object_type => options[:activity])
      end
      @activity     = options[:activity]
      @in_reply_to  = options[:in_reply_to] || []
    end

    # Yields a OStatus::Link to this entry.
    #
    # options: Can override OStatus::Link properties, such as rel.
    #
    # Usage:
    #
    #   entry = OStatus::Entry.new(:title => "Foo", :url => "http://example.com")
    #   entry.to_link(:rel => "alternate", :title => "Foo's Post")
    #
    # Generates a link with:
    #   <OStatus::Link rel="alternate" title="Foo's Post" url="http://example.com">
    def to_link(options = {})
      options = { :title => self.title,
                  :href  => self.url }.merge(options)

      OStatus::Link.new(options)
    end

    # Returns a Hash of all fields.
    def to_hash
      {
        :title => self.title,
        :author => self.author,
        :content => self.content,
        :content_type => self.content_type,
        :published => self.published,
        :updated => self.updated,
        :url => self.url,
        :id => self.id,
        :activity => self.activity,
        :in_reply_to => self.in_reply_to
      }
    end

    # Returns an Atom representation.
    def to_atom
      OStatus::Atom::Entry.from_canonical(self).to_xml
    end
  end
end
