module OStatus
  class Activity
    def initialize(activity_nodeset)
      @activity = activity_nodeset
    end

    def pick_first_node(a)
      if a.empty?
        nil
      else
        a[0].content
      end
    end
    private :pick_first_node

    def object
      pick_first_node(@activity.xpath('//activity:verb'))
    end

    def target
      pick_first_node(@activity.xpath('//activity:target'))
    end

    def verb
      pick_first_node(@activity.xpath('//activity:verb'))
    end

    def object_type
      pick_first_node(@activity.xpath('//activity:object_type'))
    end

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
