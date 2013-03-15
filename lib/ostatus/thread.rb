module OStatus
  # This will handle the Thread Atom extension (RFC 4685)
  #
  # This element is designed to specify that an entry is a response to another
  # resource. The element MUST contain a ref attribute identifying the resource
  # that is being responded to.
  #
  # More than one of these elements MAY be used to denote that an entry is in
  # response to more than one resource.
  #
  # See also: http://www.ietf.org/rfc/rfc4685.txt
  class Thread
    # The XML namespace that identifies the conforming specification
    NAMESPACE = "http://purl.org/syndication/thread/1.0"

    # A persistent, unique reference id for the resource being responded to
    # (URI). Used for comparision, not retrieval.
    attr_reader :ref

    # The optional source of the entry being responded to as a URI. This
    # specifies the location for the context of this entry. For instance,
    # it may refer to a Feed where the original response was generated.
    # MUST be a representation useful for retrieval.
    attr_reader :source

    # The target URI used to retrieve a representation of the entry being
    # responded to.
    attr_reader :href

    # The MIME type of the entry being responded to as retrieved by the href.
    attr_reader :type

    # Creates a representation of a thread reference.
    #
    # options:
    #   :ref    => A required attribute specifying the URI of the entry being
    #              responded to.
    #   :source => A URI that can be used to retrieve the source of the entry
    #              being responded to. For instance, the feed which contains
    #              it.
    #   :href   => A URI that can be used to retrieve the entry that is being
    #              responded to.
    #   :type   => The MIME type that describes the content retrieved by href.
    def initialize(options = {})
      @ref    = options[:ref]
      @source = options[:source]
      @href   = options[:href]
      @type   = options[:type]
    end
  end
end
