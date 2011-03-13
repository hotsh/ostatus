require_relative '../lib/ostatus/feed.rb'
require_relative '../lib/ostatus/author.rb'

describe OStatus::Author do
  before(:each) do
    feed = OStatus::Feed.new('test/example_feed.atom')
    @author = feed.author
    feed = OStatus::Feed.new('test/example_feed_empty_author.atom')
    @author_empty = feed.author
  end

  describe "#activity" do
    it "should return an Activity instance" do
      @author.activity.class.should eql(OStatus::Activity)
    end

    it "should give an Activity instance that is relevant to the author subtree" do
      @author.activity.object_type.should eql('http://activitystrea.ms/schema/1.0/person')
    end
  end

  describe "#uri" do
    it "should give a String containing the content of the uri tag" do
      @author.uri.should eql('http://identi.ca/user/141464')
    end

    it "should give nil when no uri is given" do
      @author_empty.uri.should eql(nil)
    end
  end

  describe "#name" do
    it "should give a String containing the content of the name tag" do
      @author.name.should eql('greenmanspirit')
    end

    it "should give nil when no name is given" do
      @author_empty.name.should eql(nil)
    end
  end

  describe "email" do
    it "should give a String containing the content of the email tag" do
      @author.email.should eql('foo@example.com')
    end

    it "should give nil when no email is given" do
      @author_empty.email.should eql(nil)
    end
  end
end
