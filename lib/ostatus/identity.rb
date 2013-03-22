module OStatus
  # Holds information about an Identity. This is more specific to identifying
  # an Author than that structure. It is generally hosted in one place and
  # not replicated. It holds identifying information that allow you to
  # ensure verification of communication with the author.
  class Identity
    # Holds the public key for this identity.
    attr_reader :public_key

    # Holds the salmon endpoint used for direct notifications for this
    # identity.
    attr_reader :salmon_endpoint

    # Holds the dialback endpoint used for capability transfer and
    # authentication for this identity.
    attr_reader :dialback_endpoint

    # Holds the activity streams inbox endpoint for this identity.
    attr_reader :activity_inbox_endpoint

    # Holds the activity streams outbox endpoint for this identity.
    attr_reader :activity_outbox_endpoint

    # Holds the url to this identity's profile.
    attr_reader :profile_page

    # Create an instance of an Identity.
    #
    # options:
    #   :public_key               => The identity's public key.
    #   :salmon_endpoint          => The salmon endpoint for this identity.
    #   :dialback_endpoint        => The dialback endpoint for this identity.
    #   :activity_inbox_endpoint  => The activity streams inbox for this
    #                                identity.
    #   :activity_outbox_endpoint => The activity streams outbox for this
    #                                identity.
    #   :profile_page             => The url for this identity's profile page.
    def initialize(options = {})
      @public_key               = options[:public_key]
      @salmon_endpoint          = options[:salmon_endpoint]
      @dialback_endpoint        = options[:dialback_endpoint]
      @activity_inbox_endpoint  = options[:activity_inbox_endpoint]
      @activity_outbox_endpoint = options[:activity_outbox_endpoint]
      @profile_page             = options[:profile_page]
    end

    # Returns a hash of the properties of the identity.
    def to_hash
      {
        :public_key               => self.public_key,
        :salmon_endpoint          => self.salmon_endpoint,
        :dialback_endpoint        => self.dialback_endpoint,
        :activity_inbox_endpoint  => self.activity_inbox_endpoint,
        :activity_outbox_endpoint => self.activity_outbox_endpoint,
        :profile_page             => self.profile_page
      }
    end
  end
end
