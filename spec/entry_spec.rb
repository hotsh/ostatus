require_relative '../lib/ostatus/feed.rb'
require_relative '../lib/ostatus/entry.rb'
require_relative '../lib/ostatus/activity.rb'

describe OStatus::Entry do
  before(:each) do
    @feed = OStatus::Feed.new('test/example_feed.atom')
    @entry = @feed.entries[0]
  end

  describe "#activity" do
    it "should return an Activity instance" do
      @entry.activity.class.should eql(OStatus::Activity)
    end
  end

  describe "#title" do
    it "should give a String containing the content of the title tag" do
      @entry.title.should eql("staples come out of the head tomorrow, oh yeah")
    end
  end

  describe "#content" do
    it "should give a String containing the content of the content tag" do
      @entry.content.should eql("staples come out of the head tomorrow, oh yeah")
    end
  end

  describe "#content_type" do
    it "should give a String containing the content of the type attribute on the content tag" do
      @entry.content_type.should eql("html")
    end
  end

  describe "#updated" do
    it "should return a DateTime instance" do
      @entry.updated.instance_of?(DateTime).should eql(true)
    end

    it "should return a DateTime representing the time given in the updated tag" do
      @entry.updated.strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2011-03-22T02:15:14+0000')
    end
  end

  describe "#published" do
    it "should return a DateTime instance" do
      @entry.published.instance_of?(DateTime).should eql(true)
    end

    it "should return a DateTime representing the time given in the published tag" do
      @entry.published.strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2011-02-21T02:15:14+0000')
    end
  end
  
  describe "#id" do
    it "should return the id given in the id tag" do
      @entry.id.should eql('http://identi.ca/notice/64991641')
    end
  end

  describe "#info" do
    it "should give a Hash" do
      @entry.info.instance_of?(Hash).should eql(true)
    end

    it "should contain the id" do
      @entry.info[:id].should eql('http://identi.ca/notice/64991641')
    end

    it "should contain the content" do
      @entry.info[:content].should eql("staples come out of the head tomorrow, oh yeah")
    end

    it "should contain the title" do
      @entry.info[:title].should eql("staples come out of the head tomorrow, oh yeah")
    end

    it "should contain the content_type" do
      @entry.info[:content_type].should eql("html")
    end

    it "should contain a Nokogiri NodeSet for the link" do
      @entry.info[:link].class.should eql(Nokogiri::XML::NodeSet)
      @entry.info[:link][0].class.should eql(Nokogiri::XML::Element)
    end
    
    it "should contain the published DateTime" do
      @entry.info[:published].class.should eql(DateTime)
      @entry.info[:published].strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2011-02-21T02:15:14+0000')
    end

    it "should contain the updated DateTime" do
      @entry.info[:updated].class.should eql(DateTime)
      @entry.info[:updated].strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2011-03-22T02:15:14+0000')
    end
  end
end
