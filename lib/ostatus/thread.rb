require 'xml/libxml'
require 'atom/xml/parser.rb'

module OStatus

  # This will parse the Thread Atom extension
  class Thread
    include Atom::Xml::Parseable
    attribute :ref, :type, :source
    uri_attribute :href

    def initialize(o)
      case o
      when XML::Reader
        if current_node_is?(o, 'in-reply-to')
          parse(o, :once => true)
        else
          raise ArgumentError, "Thread created with node other than thr:in-reply-to: #{o.name}"
        end
      when Hash
        [:href, :ref, :type, :source].each do |attr|
          self.send("#{attr}=", o[attr])
        end
      else
        raise ArgumentError, "Don't know how to handle #{o}"
      end
    end

    def length=(v)
      @length = v.to_i
    end
     
    def to_s
      self.href
    end

    def ==(o)
      o.respond_to?(:href) && o.href == self.href
    end

    def inspect
      "<OStatus::Thread href:'#{href}' type:'#{type}'>"
    end
  end
end
