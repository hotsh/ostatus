require_relative 'activity'
require_relative 'author'
require_relative 'thread'

module OStatus
  THREAD_NS = 'http://purl.org/syndication/thread/1.0'

  # Holds information about an individual entry in the Feed.
  class Entry < Atom::Entry
    include Atom::SimpleExtensions

    add_extension_namespace :activity, ACTIVITY_NS
    element 'activity:object-type'
    element 'activity:object', :class => OStatus::Author
    element 'activity:verb'
    element 'activity:target'

    add_extension_namespace :thr, THREAD_NS
    element 'thr:in-reply-to', :class => OStatus::Thread

    # This is for backwards compatibility with some implementations of Activity 
    # Streams. It should not be used, and in fact is obscured as it is not a 
    # method in OStatus::Activity.
    element 'activity:actor', :class => OStatus::Author

    namespace Atom::NAMESPACE
    element :title, :id, :summary
    element :updated, :published, :class => DateTime, :content_only => true
    element :source, :class => Atom::Source
    elements :links, :class => Atom::Link
    elements :categories, :class => Atom::Category
    element :content, :class => Atom::Content
    element :author, :class => OStatus::Author

    def activity
      Activity.new(self)
    end

    def activity= value
      if value.object_type
        self.activity_object_type = OStatus::Activity::SCHEMA_ROOT + value.object_type.to_s
      end
      self.activity_object = value.activity_object if value.object
      if value.verb
        self.activity_verb = OStatus::Activity::SCHEMA_ROOT + value.activity_verb.to_s
      end
      self.activity_target = value.activity_target if value.target
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

    def url= value
      links << Atom::Link.new(:rel => "alternate", :href => value)
    end

    def link
      links.group_by { |l| l.rel.intern }
    end

    def link= options
      links.clear << Atom::Link.new(options)
    end

    # Returns a Hash of all fields.
    def info
      {
        :activity => self.activity.info,
        :id => self.id,
        :title => self.title,
        :content => self.content,
        :link => self.link,
        :published => self.published,
        :updated => self.updated
      }
    end
  end
end
