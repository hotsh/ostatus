require_relative 'activity'
require_relative 'author'

module OStatus

  # Holds information about an individual entry in the Feed.
  class Entry < Atom::Entry
    namespace Atom::NAMESPACE

    element :title, :id, :summary
    element :updated, :published, :class => DateTime, :content_only => true
    element :source, :class => Atom::Source
    elements :links, :class => Atom::Link
    elements :authors, :class => OStatus::Author
    elements :categories, :class => Atom::Category
    element :content, :class => Atom::Content

    # Gives an instance of an OStatus::Activity that parses the fields
    # having an activity prefix.
    def activity
      Activity.new(self)
    end

    # Returns the content-type of the entry.
    def content_type
      self.content.type
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
      result = {}

      links.each do |l|
        if l.rel
          rel = l.rel.intern
          result[rel] ||= []
          result[rel] << l
        end
      end

      result
    end

    # Returns a Hash of all fields.
    def info
      {
        :activity => self.activity.info,
        :id => self.id,
        :title => self.title,
        :content => self.content,
        :content_type => self.content_type,
        :link => self.link,
        :published => self.published,
        :updated => self.updated
      }
    end
  end
end
