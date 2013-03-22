module OStatus
  module Atom
    require 'atom'

    class Entry < ::Atom::Entry
      require 'ostatus/activity'
      require 'ostatus/author'
      require 'ostatus/link'

      require 'ostatus/atom/author'
      require 'ostatus/atom/thread'
      require 'ostatus/atom/link'
      require 'ostatus/atom/source'

      require 'libxml'

      # The XML namespace that identifies the conforming specification of 'thr'
      # elements.
      THREAD_NAMESPACE = "http://purl.org/syndication/thread/1.0"

      # The XML namespace that identifies the conforming specification.
      ACTIVITY_NAMESPACE = 'http://activitystrea.ms/spec/1.0/'

      # The XML schema that identifies the conforming schema for objects.
      SCHEMA_ROOT = 'http://activitystrea.ms/schema/1.0/'

      include ::Atom::SimpleExtensions

      add_extension_namespace :activity, ACTIVITY_NAMESPACE
      element 'activity:object-type'
      element 'activity:object', :class => OStatus::Atom::Author
      element 'activity:verb'
      element 'activity:target'

      add_extension_namespace :thr, THREAD_NAMESPACE
      elements 'thr:in-reply-to', :class => OStatus::Atom::Thread

      # This is for backwards compatibility with some implementations of Activity
      # Streams. It should not be generated for Atom representation of Activity
      # Streams (although it is used in JSON)
      element 'activity:actor', :class => OStatus::Atom::Author

      element :source, :class => OStatus::Atom::Source

      namespace ::Atom::NAMESPACE
      element :title, :id, :summary
      element :updated, :published, :class => DateTime, :content_only => true
      elements :links, :class => OStatus::Atom::Link

      elements :categories, :class => ::Atom::Category
      element :content, :class => ::Atom::Content
      element :author, :class => OStatus::Atom::Author

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

      def link
        links.group_by { |l| l.rel.intern if l.rel }
      end

      def link= options
        links.clear << ::Atom::Link.new(options)
      end

      def self.from_canonical(obj)
        entry_hash = obj.to_hash

        # Ensure that the content type is encoded.
        node = XML::Node.new("content")
        node['type'] = entry_hash[:content_type] if entry_hash[:content_type]
        node << entry_hash[:content]

        xml = XML::Reader.string(node.to_s)
        xml.read
        entry_hash[:content] = ::Atom::Content.parse(xml)
        entry_hash.delete :content_type

        if entry_hash[:source]
          entry_hash[:source] = OStatus::Atom::Source.from_canonical(entry_hash[:source])
        end

        if entry_hash[:actor]
          entry_hash[:author] = OStatus::Atom::Author.from_canonical(entry_hash[:actor])
        end
        entry_hash.delete :actor

        # Encode in-reply-to fields
        entry_hash[:thr_in_reply_to] = entry_hash[:in_reply_to].map do |t|
          OStatus::Atom::Thread.new(:href => t.url,
                                    :ref  => t.id)
        end
        entry_hash.delete :in_reply_to

        entry_hash[:links] ||= []

        if entry_hash[:url]
          entry_hash[:links] << ::Atom::Link.new(:rel => "self", :href => entry_hash[:url])
        end
        entry_hash.delete :url

        object_type = entry_hash[:type]
        if object_type
          entry_hash[:activity_object_type] = SCHEMA_ROOT + object_type.to_s
        end
        entry_hash[:activity_object] = entry_hash[:object] if entry_hash[:object]
        if entry_hash[:verb]
          entry_hash[:activity_verb] = SCHEMA_ROOT + entry_hash[:verb].to_s
        end
        entry_hash[:activity_target] = entry_hash[:target] if entry_hash[:target]

        entry_hash.delete :object
        entry_hash.delete :verb
        entry_hash.delete :target
        entry_hash.delete :type

        self.new(entry_hash)
      end

      def to_canonical
        # Reform the activity type
        # TODO: Add new Base schema verbs
        object_type = self.activity_object_type
        if object_type && object_type.start_with?(SCHEMA_ROOT)
          object_type.gsub!(/^#{Regexp.escape(SCHEMA_ROOT)}/, "")
        end

        object = nil
        object = self.activity_object.to_canonical if self.activity_object

        source = self.source
        source = source.to_canonical if source
        OStatus::Activity.new(:actor        => self.author ? self.author.to_canonical : nil,
                              :id           => self.id,
                              :url          => self.url,
                              :title        => self.title,
                              :source       => source,
                              :in_reply_to  => self.thr_in_reply_to.map(&:to_canonical),
                              :content      => self.content,
                              :content_type => self.content.type,
                              :link         => self.link,
                              :object       => object,
                              :type         => object_type,
                              :verb         => self.activity_verb,
                              :target       => self.activity_target,
                              :published    => self.published,
                              :updated      => self.updated)
      end
    end
  end
end
