module OStatus
  # The generator element identifies the agent used to generate the feed.
  class Generator
    # Holds the base URI for relative URIs contained in uri.
    attr_reader :base

    # Holds the language of the name, when it exists. The language
    # should be specified as RFC 3066 as either 2 or 3 letter codes.
    # For example: 'en' for English or more specifically 'en-us'
    attr_reader :lang

    # Holds the optional uri that SHOULD produce a representation that is
    # relevant to the agent.
    attr_reader :uri

    # Holds the optional string identifying the version of the generating
    # agent.
    attr_reader :version

    # Holds the string that provides a human-readable name that identifies
    # the generating agent. The content of this field is language sensitive.
    attr_reader :name

    # Creates a representation of a generator.
    #
    # options:
    #   :base    => Optional base URI for use with a relative URI in uri.
    #   :lang    => Optional string identifying the language of the name field.
    #   :uri     => Optional string identifying the URL that SHOULD produce
    #               a representation that is relevant to the agent.
    #   :version => Optional string indicating the version of the generating
    #               agent.
    #   :name    => Optional name of the agent.
    def initialize(options = {})
      @base    = options[:base]
      @lang    = options[:lang]
      @uri     = options[:uri]
      @version = options[:version]
      @name    = options[:name]
    end

    # Yields a hash that represents the generator.
    def to_hash
      {
        :base    => self.base,
        :lang    => self.lang,
        :version => self.version,
        :uri     => self.uri,
        :name    => self.name
      }
    end
  end
end
