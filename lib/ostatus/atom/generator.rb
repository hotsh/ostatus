require 'ostatus/generator'

module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus Generator object.
    class Generator < ::Atom::Generator
      require 'open-uri'

      attribute :'xml:base'
      attribute :'xml:lang'
      attribute :version
      attribute :uri

      def self.from_canonical(obj)
        hash = obj.to_hash
        if hash[:base]
          hash[:xml_base] = hash[:base]
        end
        if hash[:lang]
          hash[:xml_lang] = hash[:lang]
        end
        hash.delete :base
        hash.delete :lang
        self.new(hash)
      end

      def to_canonical
        OStatus::Generator.new(:base    => self.xml_base,
                               :lang    => self.xml_lang,
                               :version => self.version,
                               :name    => self.name,
                               :uri     => self.uri)
      end
    end
  end
end


