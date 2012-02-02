module OStatus
  class Link < Atom::Link
    include Atom::Xml::Parseable
    attribute :rel, :type, :length, :hreflang, :title, :text
    uri_attribute :href

    # Create a link.
    #
    # +o+:: An XML::Reader containing a link element or a Hash of attributes.
    #
    def initialize(o)
      case o
      when XML::Reader
        if current_node_is?(o, 'link')
          self.text = o.read_string
          parse(o, :once => true)
        else
          raise ArgumentError, "Link created with node other than atom:link: #{o.name}"
        end
      when Hash
        [:href, :rel, :type, :length, :hreflang, :title].each do |attr|
          self.send("#{attr}=", o[attr])
        end
      else
        raise ArgumentError, "Don't know how to handle #{o}"
      end
    end

    remove_method :length=
    def length=(v)
      @length = v.to_i
    end

    def href
      @href || self.text
    end

    def to_s
      self.href
    end

    def ==(o)
      o.respond_to?(:href) && o.href == self.href
    end

    # This will fetch the URL referenced by the link.
    #
    # If the URL contains a valid feed, a Feed will be returned, otherwise,
    # the body of the response will be returned.
    #
    # TODO: Handle redirects.
    #
    def fetch(options = {})
      begin
        Atom::Feed.load_feed(URI.parse(self.href), options)
      rescue ArgumentError
        Net::HTTP.get_response(URI.parse(self.href)).body
      end
    end

    def inspect
      "<OStatus::Link href:'#{href}' type:'#{type}'>"
    end
  end
end
