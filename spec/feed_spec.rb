require_relative '../lib/ostatus/feed.rb'
require_relative '../lib/ostatus/entry.rb'

describe OStatus::Feed do
  before(:each) do
    @feed = OStatus::Feed.from_url('test/example_feed.atom')
  end

  describe "#atom" do
    it "should return a String containing the atom information" do
      @feed.atom.start_with?("<?xml").should eql(true)
    end
  end

  describe "#entries" do
    it "should return an Array of Entry instances" do
      @feed.entries.each do |entry|
        entry.instance_of?(OStatus::Entry).should eql(true)
      end
    end
  end
end
