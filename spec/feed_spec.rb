require_relative 'helper'
require_relative '../lib/ostatus/feed.rb'

describe OStatus::Feed do
  describe "#initialize" do
    it "should detect a feed URI in an HTML page" do
      @feed = OStatus::Feed.from_url('test/example_page.html')
      @feed.url.must_equal 'test/example_feed.atom'
    end
  end

  describe "with example_feed.atom" do
    before(:each) do
      @feed = OStatus::Feed.from_url('test/example_feed.atom')
    end

    describe "#atom" do
      it "should return a String containing the atom information" do
        @feed.atom.start_with?("<?xml").must_equal(true)
      end
    end

    describe "#hubs" do
      it "should return a String containing the hub url given in the link tag" do
        @feed.hubs.must_equal(['http://identi.ca/main/push/hub', 'http://identi.ca/main/push/hub2'])
      end
    end

    describe "#salmon" do
      it "should return a String containing the salmon url given in the link tag" do
        @feed.salmon.must_equal('http://identi.ca/main/salmon/user/141464')
      end
    end

    describe "#entries" do
      it "should return an Array of Entry instances" do
        @feed.entries.each do |entry|
          entry.instance_of?(OStatus::Entry).must_equal(true)
        end
      end
    end
  end
end
