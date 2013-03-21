require 'ostatus/activity'
require 'ostatus/author'
require 'ostatus/category'
require 'ostatus/generator'

require 'ostatus/atom/entry'
require 'ostatus/atom/generator'
require 'ostatus/atom/category'
require 'ostatus/atom/author'
require 'ostatus/atom/link'

module OStatus
  require 'atom'

  module Atom
    # This class represents an OStatus Feed object.
    class Feed < ::Atom::Feed
      require 'open-uri'

      include ::Atom::SimpleExtensions

      namespace ::Atom::NAMESPACE

      add_extension_namespace :poco, OStatus::Author::NAMESPACE
      add_extension_namespace :activity, OStatus::Activity::NAMESPACE
      element :id, :rights, :icon, :logo
      element :generator, :class => OStatus::Atom::Generator
      element :title, :class => ::Atom::Content
      element :subtitle, :class => ::Atom::Content
      element :published, :class => Time, :content_only => true
      element :updated, :class => Time, :content_only => true
      elements :links, :class => ::Atom::Link
      elements :authors, :class => OStatus::Atom::Author
      elements :contributors, :class => OStatus::Atom::Author
      elements :categories, :class => OStatus::Atom::Category
      elements :entries, :class => OStatus::Atom::Entry

      # Creates an Atom generator for the given OStatus::Feed.
      def self.from_canonical(obj)
        hash = obj.to_hash
        hash[:entries].map! {|e|
          OStatus::Atom::Entry.from_canonical(e)
        }

        # Ensure that the generator is encoded.
        if hash[:generator]
          hash[:generator] = OStatus::Atom::Generator.from_canonical(hash[:generator])
        end

        hash[:links] ||= []

        if hash[:salmon_url]
          hash[:links] << ::Atom::Link.new(:rel => "salmon", :href => hash[:salmon_url])
        end
        hash.delete :salmon_url

        if hash[:url]
          hash[:links] << ::Atom::Link.new(:rel => "self", :href => hash[:url])
        end
        hash.delete :url

        hash[:hubs].each {|h|
          hash[:links] << ::Atom::Link.new(:rel => "hub", :href => h)
        }
        hash.delete :hubs

        hash[:authors].map! {|a|
          OStatus::Atom::Author.from_canonical(a)
        }

        hash[:contributors].map! {|a|
          OStatus::Atom::Author.from_canonical(a)
        }

        hash[:categories].map! {|c|
          OStatus::Atom::Category.from_canonical(c)
        }

        # title/subtitle content type
        node = XML::Node.new("title")
        node['type'] = hash[:title_type] if hash[:title_type]
        node << hash[:title]

        xml = XML::Reader.string(node.to_s)
        xml.read
        hash[:title] = ::Atom::Content.parse(xml)
        hash.delete :title_type

        if hash[:subtitle]
          node = XML::Node.new("subtitle")
          node['type'] = hash[:subtitle_type] if hash[:subtitle_type]
          node << hash[:subtitle]

          xml = XML::Reader.string(node.to_s)
          xml.read
          hash[:subtitle] = ::Atom::Content.parse(xml)
        else
          hash.delete :subtitle
        end
        hash.delete :subtitle_type

        self.new(hash)
      end

      def to_canonical
        generator = nil
        generator = self.generator.to_canonical if self.generator

        salmon_url = nil
        if self.link('salmon').any?
          salmon_url = self.link('salmon').first.href
        end

        url = self.url

        categories = self.categories.map(&:to_canonical)

        OStatus::Feed.new(:title         => self.title,
                          :title_type    => self.title ? self.title.type : nil,
                          :subtitle      => self.subtitle,
                          :subtitle_type => self.subtitle ? self.subtitle.type : nil,
                          :id            => self.id,
                          :url           => url,
                          :categories    => categories,
                          :icon          => self.icon,
                          :logo          => self.logo,
                          :rights        => self.rights,
                          :published     => self.published,
                          :updated       => self.updated,
                          :entries       => self.entries.map(&:to_canonical),
                          :authors       => self.authors.map(&:to_canonical),
                          :contributors  => self.contributors.map(&:to_canonical),
                          :hubs          => self.hubs,
                          :salmon_url    => salmon_url,
                          :generator     => generator)
      end

      # Returns an array of ::Atom::Link instances for all link tags
      # that have a rel equal to that given by attribute.
      #
      # For example:
      #   link(:hub).first.href -- Gets the first link tag with rel="hub" and
      #                            returns the contents of the href attribute.
      #
      def link(attribute)
        links.find_all { |l| l.rel == attribute.to_s }
      end

      # Returns an array of URLs for each hub link tag.
      def hubs
        link('hub').map { |link| link.href }
      end

      # Returns a string of the url for this feed.
      def url
        if links.alternate
          links.alternate.href
        elsif links.self
          links.self.href
        else
          links.map.each do |l|
            l.href
          end.compact.first
        end
      end
    end
  end
end
