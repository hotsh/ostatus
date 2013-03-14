require_relative 'helper'
require_relative '../lib/ostatus/author.rb'

describe OStatus::Author do
  before(:each) do
    feed = OStatus::Feed.from_url('test/example_feed.atom')
    @author = feed.author
    feed = OStatus::Feed.from_url('test/example_feed_empty_author.atom')
    @author_empty = feed.author
  end

  describe "#activity" do
    it "should return an Activity instance" do
      @author.activity.class.must_equal(OStatus::Activity)
    end

    it "should give an Activity instance that is relevant to the author subtree" do
      @author.activity.object_type.must_equal(:person)
    end
  end

  describe "#portable_contacts" do
    it "should return an PortableContacts instance" do
      @author.portable_contacts.class.must_equal(OStatus::PortableContacts)
    end

    it "should give an PortableContacts instance that is relevant to the author subtree" do
      @author.portable_contacts.preferred_username.must_equal('greenmanspirit')
    end
  end

  describe "#uri" do
    it "should give a String containing the content of the uri tag" do
      @author.uri.must_equal('http://identi.ca/user/141464')
    end

    it "should give nil when no uri is given" do
      @author_empty.uri.must_equal(nil)
    end
  end

  describe "#name" do
    it "should give a String containing the content of the name tag" do
      @author.name.must_equal('greenmanspirit')
    end

    it "should give nil when no name is given" do
      @author_empty.name.must_equal(nil)
    end
  end

  describe "email" do
    it "should give a String containing the content of the email tag" do
      @author.email.must_equal('foo@example.com')
    end

    it "should give nil when no email is given" do
      @author_empty.email.must_equal(nil)
    end
  end
end
