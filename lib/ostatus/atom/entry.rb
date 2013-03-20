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

      include ::Atom::SimpleExtensions

      add_extension_namespace :activity, OStatus::Activity::NAMESPACE
      element 'activity:object-type'
      element 'activity:object', :class => OStatus::Atom::Author
      element 'activity:verb'
      element 'activity:target'

      add_extension_namespace :thr, OStatus::Entry::THREAD_NAMESPACE
      elements 'thr:in-reply-to', :class => OStatus::Atom::Thread

      # This is for backwards compatibility with some implementations of Activity
      # Streams. It should not be used, and in fact is obscured as it is not a
      # method in OStatus::Activity.
      element 'activity:actor', :class => OStatus::Atom::Author

      element :source, :class => OStatus::Atom::Source

      namespace ::Atom::NAMESPACE
      element :title, :id, :summary
      element :updated, :published, :class => DateTime, :content_only => true
      elements :links, :class => OStatus::Atom::Link

      elements :categories, :class => ::Atom::Category
      element :content, :class => ::Atom::Content
      element :author, :class => OStatus::Atom::Author

      def activity
        # Reform the Activity object type
        object_type = self.activity_object_type
        if object_type && object_type.start_with?(OStatus::Activity::SCHEMA_ROOT)
          object_type.gsub!(/^#{Regexp.escape(OStatus::Activity::SCHEMA_ROOT)}/, "")
        end

        object = nil
        object = self.activity_object.to_canonical if self.activity_object

        Activity.new(:object_type => object_type,
                     :object => object,
                     :target => self.activity_target,
                     :verb => self.activity_verb)
      end

      def activity= value
        return if value.nil?
        if value.object_type
          self.activity_object_type = OStatus::Activity::SCHEMA_ROOT + value.object_type.to_s
        end
        self.activity_object = value.object if value.object
        if value.verb
          self.activity_verb = OStatus::Activity::SCHEMA_ROOT + value.verb.to_s
        end
        self.activity_target = value.target if value.target
      end

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

        if entry_hash[:author]
          entry_hash[:author] = OStatus::Atom::Author.from_canonical(entry_hash[:author])
        end

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

        self.new(entry_hash)
      end

      def to_canonical
        source = self.source
        source = source.to_canonical if source
        OStatus::Entry.new(:author       => self.author ? self.author.to_canonical : nil,
                           :activity     => self.activity,
                           :id           => self.id,
                           :url          => self.url,
                           :title        => self.title,
                           :source       => source,
                           :in_reply_to  => self.thr_in_reply_to.map(&:to_canonical),
                           :content      => self.content,
                           :content_type => self.content.type,
                           :link         => self.link,
                           :published    => self.published,
                           :updated      => self.updated)
      end
    end
  end
end
