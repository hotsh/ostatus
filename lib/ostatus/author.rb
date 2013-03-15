require 'ostatus/activity'
require 'ostatus/portable_contacts'

module OStatus
  require 'atom'

  # Holds information about the author of the Feed.
  class Author
    require 'date'

    # The uri that uniquely identifies the author.
    attr_reader :uri

    # The email address of the author.
    attr_reader :email

    # The OStatus::PortableContacts that represents the author.
    attr_reader :portable_contacts

    # The name of the author
    attr_reader :name

    # Creates a representating of an author.
    #
    # options:
    #   uri               => The uri that uniquely identifies this author.
    #   name              => The name of the author. Defaults: "anonymous"
    #   email             => The email of the author.
    #   portable_contacts => The OStatus::PortableContacts representing this
    #                        author.
    def initialize(options = {})
      @uri = options[:uri]
      @name = options[:name] || "anonymous"
      @email = options[:email]
      @portable_contacts = options[:portable_contacts]
    end
  end
end
