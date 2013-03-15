module OStatus
  # Holds information about the extended contact information
  # in the Feed given in the Portable Contacts specification.
  class PortableContacts
    # The XML namespace the specifies this content.
    NAMESPACE = 'http://portablecontacts.net/spec/1.0'

    # Holds the id that represents this contact.
    attr_reader :id

    # Holds the nickname of this contact.
    attr_reader :nickname

    # Holds a hash representing information about the name of this contact.
    #
    # contains one or more of the following:
    #   :formatted         => The full name of the contact
    #   :family_name       => The family name. "Last name" in Western contexts.
    #   :given_name        => The given name. "First name" in Western contexts.
    #   :middle_name       => The middle name.
    #   :honorific_prefix  => "Title" in Western contexts. (e.g. "Mr." "Mrs.")
    #   :honorific_suffix  => "Suffix" in Western contexts. (e.g. "Esq.")
    attr_reader :name

    # Holds a hash representing the address of the contact.
    #
    # contains one or more of the following:
    #   :formatted      => A formatted representating of the address. May
    #                     contain newlines.
    #   :street_address => The full street address. May contain newlines.
    #   :locality       => The city or locality component.
    #   :region         => The state or region component.
    #   :postal_code    => The zipcode or postal code component.
    #   :country        => The country name component.
    attr_reader :address

    # Holds a hash representing an organization for this contact.
    #
    # contains one or more of the following:
    #   :name        => The name of the organization (e.g. company, school,
    #                   etc) This field is required. Will be used for sorting.
    #   :department  => The department within the organization.
    #   :title       => The title or role within the organization.
    #   :type        => The type of organization. Canonical values include
    #                   "job" or "school"
    #   :start_date  => A DateTime representing when the contact joined
    #                   the organization.
    #   :end_date    => A DateTime representing when the contact left the
    #                   organization.
    #   :location    => The physical location of this organization.
    #   :description => A free-text description of the role this contact
    #                   played in this organization.
    attr_reader :organization

    # Holds a hash representing information about an account held by this
    # contact.
    #
    # contains one or more of the following:
    #   :domain   => The top-most authoriative domain for this account. (e.g.
    #                "twitter.com") This is the primary field. Is required.
    #                Used for sorting.
    #   :username => An alphanumeric username, typically chosen by the user.
    #   :userid   => A user id, typically assigned, that uniquely refers to
    #                the user.
    attr_reader :account

    # Holds the gender of this contact.
    attr_reader :gender

    # Holds a note for this contact.
    attr_reader :note

    # Holds the display name for this contact.
    attr_reader :display_name

    # Holds the preferred username of this contact.
    attr_reader :preferred_username

    # Holds a DateTime that represents when this contact was last modified.
    attr_reader :updated

    # Holds a DateTime that represents when this contact was originally
    # published.
    attr_reader :published

    # Holds a DateTime representing this contact's birthday.
    attr_reader :birthday

    # Holds a DateTime representing a contact's anniversary.
    attr_reader :anniversary

    # Creates a new representation of a PortableContact.
    #
    # options:
    #   id                 => The identifier that uniquely identifies the
    #                         contact.
    #   nickname           => The nickname of the contact.
    #   gender             => The gender of the contact.
    #   note               => A note for this contact.
    #   display_name       => The display name for this contact.
    #   preferred_username => The preferred username for this contact.
    #   updated            => A DateTime representing when this contact was
    #                         last updated.
    #   published          => A DateTime representing when this contact was
    #                         originally created.
    #   birthday           => A DateTime representing a birthday for this
    #                         contact.
    #   anniversary        => A DateTime representing an anniversary for this
    #                         contact.
    #   name               => A Hash representing the name of the contact.
    #   organization       => A Hash representing the organization of which the
    #                         contact belongs.
    #   account            => A Hash describing the authorative account for the
    #                         author.
    #   address            => A Hash describing the address of the contact.
    def initialize(options = {})
      @id = options[:id]
      @name = options[:name]
      @gender = options[:gender]
      @note = options[:note]
      @nickname = options[:nickname]
      @display_name = options[:display_name]
      @preferred_username = options[:preferred_username]
      @updated = options[:updated]
      @published = options[:published]
      @birthday = options[:birthday]
      @anniversary = options[:anniversary]

      @name = options[:name]
      @organization = options[:organization]
      @account = options[:account]
      @address = options[:address]
    end
  end
end
