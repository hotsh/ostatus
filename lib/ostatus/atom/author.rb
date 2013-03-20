require 'ostatus/activity'
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

      add_extension_namespace :poco, OStatus::Author::NAMESPACE
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
        name = self[OStatus::Author::NAMESPACE, 'name'].first
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

      def self.from_canonical(obj)
        hash = obj.to_hash
        hash.keys.each do |k|
          to_k = k
          if k == :display_name
            to_k = :displayName
          elsif k == :preferred_username
            to_k = :preferredUsername
          end

          if k == :extended_name
            if hash[:extended_name]
              hash[:"poco_name"] = OStatus::Atom::Name.new(hash[:extended_name])
            end
            hash.delete :extended_name
          elsif k == :organization
            if hash[:organization]
              hash[:"poco_organization"] = OStatus::Atom::Organization.new(hash[:organization])
            end
            hash.delete :organization
          elsif k == :address
            if hash[:address]
              hash[:"poco_address"] = OStatus::Atom::Address.new(hash[:address])
            end
            hash.delete :address
          elsif k == :account
            if hash[:account]
              hash[:"poco_account"] = OStatus::Atom::Account.new(hash[:account])
            end
            hash.delete :account
          elsif (k != :uri) && (k != :name) && (k != :email)
            hash[:"poco_#{to_k}"] = hash[k]
            hash.delete k
          end
        end

        self.new(hash)
      end

      def to_canonical
        organization = self.poco_organization
        organization = organization.to_canonical if organization

        address = self.poco_address
        address = address.to_canonical if address

        account = self.poco_account
        account = account.to_canonical if account

        ext_name = self.poco_name
        ext_name = ext_name.to_canonical if ext_name
        OStatus::Author.new(:id => self.poco_id,
                            :extended_name => ext_name,
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
                            :anniversary => self.poco_anniversary,
                            :uri => self.uri,
                            :email => self.email,
                            :name => self.name)
      end
    end
  end
end
