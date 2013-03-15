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

    # Create a new entry with the given content.
    #
    # options:
    #   :title        => The title of the entry. Defaults: "Untitled"
    #   :author       => A OStatus::Author responsible for generating this entry.
    #   :content      => The content of the entry. Defaults: ""
    #   :content_type => The MIME type of the content.
    #   :published    => The DateTime depicting when the entry was originally
    #                    published. Defaults: DateTime.now
    #   :updated      => The DateTime depicting when the entry was modified.
    #   :url          => The canonical url of the entry.
    #   :id           => The unique id that identifies this entry.
    #   :activity     => The activity this entry represents.
    def initialize(options = {})
      @title        = options[:title] || "Untitled"
      @author       = options[:author]
      @content      = options[:content] || ""
      @content_type = options[:content_type]
      @published    = options[:published] || DateTime.now
      @updated      = options[:updated]
      @url          = options[:url]
      @id           = options[:id]
      @activity     = options[:activity]
    end


    # Returns a Hash of all fields.
    def info
      {
        :title => self.title,
        :author => self.author,
        :content => self.content,
        :content_type => self.content_type,
        :published => self.published,
        :updated => self.updated,
        :url => self.url,
        :id => self.id,
        :activity => self.activity
      }
    end

    # Returns an Atom representation.
    def to_atom
      require 'ostatus/atom/entry'

      OStatus::Atom::Entry.new(self.info).to_xml
    end
  end
end
