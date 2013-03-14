module OStatus
  # This class represents an Activity object for an OStatus entry.
  class Activity
    NAMESPACE = 'http://activitystrea.ms/spec/1.0/'
    SCHEMA_ROOT = 'http://activitystrea.ms/schema/1.0/'

    def initialize(entry)
      @entry = entry
    end

    # Returns the object field or nil if it does not exist.
    def object
      if @entry.is_a? Hash
        @entry[:object]
      else
        @entry.activity_object
      end
    end

    # Returns the target field or nil if it does not exist.
    def target
      if @entry.is_a? Hash
        @entry[:object]
      else
        @entry.activity_target
      end
    end

    # Returns the verb field or nil if it does not exist.
    # :favorite, :follow, :like, :"make-friend", :join, :play,
    # :post, :save, :share, :tag, :update
    def verb
      if @entry.is_a? Hash
        @entry[:object]
      else
        obj = @entry.activity_verb
        if obj.nil?
          nil
        elsif obj.start_with?(SCHEMA_ROOT)
          obj[SCHEMA_ROOT.size..-1].intern unless obj.nil?
        else
          obj
        end
      end
    end

    def verb= value
      if @entry.is_a? Hash
        @entry[:object] = value
      else
        if [:favorite, :follow, :like, :"make-friend", :join,
          :play, :save, :share, :tag, :update].include? value
          value = "#{SCHEMA_ROOT}#{value}"
        end

        @entry.activity_verb = value
      end
    end

    # Returns the object-type field or nil if it does not exist.
    # :article, :audio, :bookmark, :comment, :file, :folder, :group,
    # :list, :note, :person, :photo, :"photo-album", :place, :playlist,
    # :product, :review, :service, :status, :video
    def object_type
      if @entry.is_a? Hash
        @entry[:object_type]
      else
        obj = @entry.activity_object_type
        if obj.nil?
          nil
        elsif obj.start_with?(SCHEMA_ROOT)
          obj[SCHEMA_ROOT.size..-1].intern unless obj.nil?
        else
          obj
        end
      end
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
