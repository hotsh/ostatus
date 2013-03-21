require_relative 'helper'
require_relative '../lib/ostatus/activity.rb'

describe OStatus::Activity do
  describe "#initialize" do
    it "should store an object" do
      OStatus::Activity.new(:object => "object").object.must_equal "object"
    end

    it "should store an type" do
      OStatus::Activity.new(:type => :audio).type.must_equal :audio
    end

    it "should store a verb" do
      OStatus::Activity.new(:verb => :follow).verb.must_equal :follow
    end

    it "should store a target" do
      OStatus::Activity.new(:target => "target").target.must_equal "target"
    end

    it "should store a title" do
      OStatus::Activity.new(:title => "My Title").title.must_equal "My Title"
    end

    it "should store an actor" do
      actor = mock('author')
      OStatus::Activity.new(:actor => actor).actor.must_equal actor
    end

    it "should store content" do
      OStatus::Activity.new(:content => "Hello").content.must_equal "Hello"
    end

    it "should store the content type" do
      OStatus::Activity.new(:content_type => "txt").content_type.must_equal "txt"
    end

    it "should store the published date" do
      time = mock('date')
      OStatus::Activity.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('date')
      OStatus::Activity.new(:updated => time).updated.must_equal time
    end

    it "should store a source feed" do
      feed = mock('feed')
      OStatus::Activity.new(:source => feed).source.must_equal feed
    end

    it "should store a url" do
      OStatus::Activity.new(:url => "url").url.must_equal "url"
    end

    it "should store an id" do
      OStatus::Activity.new(:id => "id").id.must_equal "id"
    end

    it "should store an array of threads" do
      thread = mock('entry')
      OStatus::Activity.new(:in_reply_to => [thread]).in_reply_to.must_equal [thread]
    end

    it "should store an array of threads when only given one entry" do
      thread = mock('entry')
      OStatus::Activity.new(:in_reply_to => thread).in_reply_to.must_equal [thread]
    end

    it "should store an empty array of threads by default" do
      OStatus::Activity.new.in_reply_to.must_equal []
    end

    it "should default the content to '' if not given" do
      OStatus::Activity.new.content.must_equal ''
    end

    it "should default the title to 'Untitled' if not given" do
      OStatus::Activity.new.title.must_equal "Untitled"
    end
  end
end
