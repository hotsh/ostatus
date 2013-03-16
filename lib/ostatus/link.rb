module OStatus
  require 'atom'

  class Link
    # The URL for the related resource.
    attr_reader :href

    # A string indicating the relationship type with the current
    # document.
    #
    # Standard:
    #   "alternate" = Signifies that the URL in href identifies an alternative
    #                 version of the resource described by the containing
    #                 element.
    #   "related"   = Signifies that the URL in href identifies a resource that
    #                 is related to the contained resource. For example, the
    #                 feed for a site that discusses the performance of the
    #                 search engine at "http://search.example.com" might
    #                 contain, as a link of Feed, a related link to that
    #                 "http://search.example.com".
    #   "self"      = Signifies that href contains a URL to the containing
    #                 resource.
    #   "enclosure" = Signifies that the URL in href identifies a related
    #                 resource that is potentially large in size and
    #                 require special handling. SHOULD use the length field.
    #   "via"       = Signifies that the URL in href identifies a resource that
    #                 is the source of the information provided in the
    #                 containing element.
    attr_reader :rel

    # Advises to the content MIME type of the linked resource.
    attr_reader :type

    # Advises to the language of the linked resource. When used with
    # rel="alternate" it depicts a translated version of the entry.
    # Use with a RFC3066 language tag.
    attr_reader :hreflang

    # Conveys human-readable information about the linked resource.
    attr_reader :title

    # Advises the length of the linked content in number of bytes. It is simply
    # a hint about the length based upon prior information. It may change, and
    # cannot override the actual content length.
    attr_reader :length

    def initialize(options = {})
      @href     = options[:href]
      @rel      = options[:rel]
      @type     = options[:type]
      @hreflang = options[:hreflang]
      @title    = options[:title]
      @length   = options[:length]
    end
  end
end
