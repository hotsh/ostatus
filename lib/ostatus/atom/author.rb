require 'ostatus/activity'
require 'ostatus/portable_contacts'

module OStatus
  require 'atom'

  module Atom
    # Holds information about the author of the Feed.
    class Author < ::Atom::Person
      require 'date'

      include ::Atom::SimpleExtensions

      add_extension_namespace :activity, OStatus::Activity::NAMESPACE
      element 'activity:object-type'

      namespace ::Atom::NAMESPACE
      element :email
      element :uri

      elements :links, :class => ::Atom::Link

      add_extension_namespace :poco, OStatus::PortableContacts::NAMESPACE
      element 'poco:id'
      element 'poco:displayName'
      element 'poco:nickname'
      element 'poco:updated',     :class => DateTime, :content_only => true
      element 'poco:published',   :class => DateTime, :content_only => true
      element 'poco:birthday',    :class => Date, :content_only => true
      element 'poco:anniversary', :class => Date, :content_only => true
      element 'poco:gender'
      element 'poco:note'
      element 'poco:preferredUsername'
      element 'poco:connected'

      def initialize *args
        self.activity_object_type = "http://activitystrea.ms/schema/1.0/person"
        super(*args)
      end

      # unfortunately ratom doesn't handle elements with the same local name well.
      # this is a workaround for that.
      attr_writer :name, :poco_name

      def name
        @name or self[::Atom::NAMESPACE, 'name'].first
      end

      def poco_name
        @poco_name or self[OStatus::PortableContacts::NAMESPACE, 'name'].first
      end

      def to_xml(*args)
        x = super(*args)

        if self.name
          node = XML::Node.new('name')
          node << self.name
          x << node
        end

        if self.poco_name
          node = XML::Node.new('poco:name')
          node << self.poco_name
          x << node
        end

        x
      end

      # Gives an instance of an OStatus::Activity that parses the fields
      # having an activity prefix.
      def activity
        OStatus::Activity.new(self)
      end

      # Returns an instance of a PortableContacts that further describe the
      # author's contact information, if it exists.
      def portable_contacts
        OStatus::PortableContacts.new(:id => self.poco_id,
                                      :name => self.poco_name,
                                      :gender => self.poco_gender,
                                      :note => self.poco_note,
                                      :nickname => self.poco_nickname,
                                      :display_name => self.poco_displayName,
                                      :preferred_username => self.poco_preferredUsername,
                                      :updated => self.poco_updated,
                                      :published => self.poco_published,
                                      :birthday => self.poco_birthday,
                                      :anniversary => self.poco_anniversary)
      end

      def to_canonical
        OStatus::Author.new(:portable_contacts => self.portable_contacts,
                            :uri => self.uri,
                            :email => self.email,
                            :name => self.name)
      end

      def portable_contacts= poco
        [ 'id', 'name', 'nickname', 'updated', 'published', 'birthday',
          'anniversary', 'gender', 'note', 'connected'].each do |p|
          v = poco.send(p)
          self.send("poco_#{p}=", v) if v
          end

        self.poco_displayName = poco.display_name if poco.display_name
        self.poco_preferredUsername = poco.preferred_username if poco.preferred_username
      end
    end
  end
end
