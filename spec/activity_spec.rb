require_relative 'helper'
require_relative '../lib/ostatus/activity.rb'

describe OStatus::Activity do
  before do
    feed = OStatus::Feed.from_url('test/example_feed.atom')
    entry = feed.entries[0]
    @activity = entry.activity
    entry = feed.entries[1]
    @activity_empty = entry.activity
  end

  describe "#object" do
    it "should give an Author containing the content of the activity:object tag" do
      @activity.object.class.must_equal(OStatus::Author)
    end

    it "should give nil when no activity:object was given" do
      @activity_empty.object.must_equal(nil)
    end
  end

  describe "#object-type" do
    it "should give a String containing the content of the activity:object-type tag" do
      @activity.object_type.must_equal(:note)
    end

    it "should give nil when no activity:object-type was given" do
      @activity_empty.object_type.must_equal(nil)
    end
  end

  describe "#verb" do
    it "should give a String containing the content of the activity:verb tag" do
      @activity.verb.must_equal(:post)
    end

    it "should give nil when no activity:verb was given" do
      @activity_empty.verb.must_equal(nil)
    end
  end

  describe "#target" do
    it "should give a String containing the content of the activity:target tag" do
      @activity.target.must_equal('Barbaz')
    end

    it "should give nil when no activity:target was given" do
      @activity_empty.target.must_equal(nil)
    end
  end
end
