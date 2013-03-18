require 'ostatus/activity'
require 'ostatus/portable_contacts'
require 'ostatus/atom/name'
require 'ostatus/atom/address'
require 'ostatus/atom/account'
require 'ostatus/atom/organization'

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
      element 'poco:organization', :class => OStatus::Atom::Organization
      element 'poco:address',      :class => OStatus::Atom::Address
      element 'poco:account',      :class => OStatus::Atom::Account
      element 'poco:displayName'
      element 'poco:nickname'
      element 'poco:updated',     :class => DateTime, :content_only => true
      element 'poco:published',   :class => DateTime, :content_only => true
      element 'poco:birthday',    :class => Date,     :content_only => true
      element 'poco:anniversary', :class => Date,     :content_only => true
      element 'poco:gender'
      element 'poco:note'
      element 'poco:preferredUsername'

      # unfortunately ratom doesn't handle elements with the same local name well.
      # this is a workaround for that.
      attr_writer :name, :poco_name

      def name
        @name or self[::Atom::NAMESPACE, 'name'].first
      end

      def poco_name
        return @poco_name if @poco_name
        name = self[OStatus::PortableContacts::NAMESPACE, 'name'].first
        if name
          name = "<name>#{name}</name>"
          reader = XML::Reader.string(name)
          reader.read
          reader.read
          OStatus::Atom::Name.new(reader)
        else
          nil
        end
      end

      def to_xml(*args)
        x = super(*args)

        if self.name
          node = XML::Node.new('name')
          node << self.name
          x << node
        end

        if self.poco_name
          x << self.poco_name.to_xml(true, root_name = 'poco:name')
        end

        x
      end

      def initialize *args
        self.activity_object_type = "http://activitystrea.ms/schema/1.0/person"
        super(*args)
      end

      # Gives an instance of an OStatus::Activity that parses the fields
      # having an activity prefix.
      def activity
        OStatus::Activity.new(self)
      end

      # Returns an instance of a PortableContacts that further describe the
      # author's contact information, if it exists.
      def portable_contacts
        organization = self.poco_organization
        organization = organization.to_canonical if organization

        address = self.poco_address
        address = address.to_canonical if address

        account = self.poco_account
        account = account.to_canonical if account

        name = self.poco_name
        name = name.to_canonical if name
        OStatus::PortableContacts.new(:id => self.poco_id,
                                      :name => name,
                                      :organization => organization,
                                      :address => address,
                                      :account => account,
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

      def self.from_canonical(obj)
        hash = obj.to_hash
        if hash[:portable_contacts]
          poco_hash = hash[:portable_contacts].to_hash
          poco_hash.keys.each do |k|
            next if poco_hash[k].nil?

            to_k = k
            if k == :display_name
              to_k = :displayName
            elsif k == :preferred_username
              to_k = :preferredUsername
            end

            if k == :name
              hash[:"poco_name"] = OStatus::Atom::Name.new(poco_hash[:name])
            elsif k == :organization
              hash[:"poco_organization"] = OStatus::Atom::Organization.new(poco_hash[:organization])
            elsif k == :address
              hash[:"poco_address"] = OStatus::Atom::Address.new(poco_hash[:address])
            elsif k == :account
              hash[:"poco_account"] = OStatus::Atom::Account.new(poco_hash[:account])
            else
              hash[:"poco_#{to_k}"] = poco_hash[k]
            end
          end
        end
        hash.delete :portable_contacts

        self.new(hash)
      end

      def to_canonical
        OStatus::Author.new(:portable_contacts => self.portable_contacts,
                            :uri => self.uri,
                            :email => self.email,
                            :name => self.name)
      end
    end
  end
end
