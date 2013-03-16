require_relative 'helper'
require_relative '../lib/ostatus/activity.rb'

describe OStatus::Activity do
  describe "#initialize" do
    it "should store an object" do
      OStatus::Activity.new(:object => "object").object.must_equal "object"
    end

    it "should store an object type" do
      OStatus::Activity.new(:object_type => :audio).object_type.must_equal :audio
    end

    it "should store a verb" do
      OStatus::Activity.new(:verb => :follow).verb.must_equal :follow
    end

    it "should store a target" do
      OStatus::Activity.new(:target => "target").target.must_equal "target"
    end
  end
end
