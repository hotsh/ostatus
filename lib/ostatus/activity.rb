module OStatus
  # This class represents an Activity object for an OStatus::Entry.
  class Activity
    # The XML namespace that identifies the conforming specification.
    NAMESPACE = 'http://activitystrea.ms/spec/1.0/'

    # The XML schema that identifies the conforming schema for objects.
    SCHEMA_ROOT = 'http://activitystrea.ms/schema/1.0/'

    # The object of this activity.
    attr_reader :object

    # The type of object for this activity.
    #
    # The field can be a String for uncommon types. Several are standard:
    #   :article, :audio, :bookmark, :comment, :file, :folder, :group,
    #   :list, :note, :person, :photo, :"photo-album", :place, :playlist,
    #   :product, :review, :service, :status, :video
    attr_reader :object_type

    # The action being invoked in this activity.
    #
    # The field can be a String for uncommon verbs. Several are standard:
    #   :favorite, :follow, :like, :"make-friend", :join, :play,
    #   :post, :save, :share, :tag, :update
    attr_reader :verb

    # The target of the action.
    attr_reader :target

    # Creates a new representation of an activity.
    #
    # options:
    #   :object      => The object of this activity.
    #   :object_type => The type of object for this activity.
    #   :target      => The target of this activity.
    #   :verb        => The action of the activity.
    def initialize(options = {})
      @entry = entry
    end

    # Returns a hash of all relevant fields.
    def info
      {
        :object => self.object,
        :target => self.target,
        :verb => self.verb,
        :object_type => self.object_type
      }
    end
  end
end
