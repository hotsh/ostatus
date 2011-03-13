require_relative '../lib/ostatus/feed.rb'
require_relative '../lib/ostatus/entry.rb'
require_relative '../lib/ostatus/activity.rb'

describe OStatus::PortableContacts do
  before(:each) do
    feed = OStatus::Feed.new('test/example_feed.atom')
    author = feed.author
    @poco = author.portable_contacts
    feed = OStatus::Feed.new('test/example_feed_false_connected.atom')
    author = feed.author
    @poco_false = author.portable_contacts
    feed = OStatus::Feed.new('test/example_feed_empty_author.atom')
    author = feed.author
    @poco_empty = author.portable_contacts
  end

  describe "#id" do
    it "should give a String containing the content of the title tag" do
      @poco.id.should eql('foobar')
    end

    it "should give nil if the id tag does not exist" do
      @poco_empty.id.should eql(nil)
    end
  end

  describe "#display_name" do
    it "should give a String containing the content of the displayName tag" do
      @poco.display_name.should eql('Adam Hobaugh')
    end

    it "should give nil if the displayName tag does not exist" do
      @poco_empty.display_name.should eql(nil)
    end
  end

  describe "#name" do
    it "should give a String containing the content of the name tag" do
      @poco.name.should eql('barbaz')
    end

    it "should give nil if the name tag does not exist" do
      @poco_empty.name.should eql(nil)
    end
  end

  describe "#nickname" do
    it "should give a String containing the content of the nickname tag" do
      @poco.nickname.should eql('spaz')
    end

    it "should give nil if the nickname tag does not exist" do
      @poco_empty.nickname.should eql(nil)
    end
  end

  describe "#published" do
    it "should give a DateTime instance" do
      @poco.published.class.should eql(DateTime)
    end

    it "should give a DateTime containing the content of the published tag" do
      @poco.published.strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2012-02-21T02:15:14+0000')
    end

    it "should give nil if the published tag does not exist" do
      @poco_empty.published.should eql(nil)
    end
  end

  describe "#updated" do
    it "should give a DateTime instance" do
      @poco.updated.class.should eql(DateTime)
    end

    it "should give a DateTime containing the content of the updated tag" do
      @poco.updated.strftime("%Y-%m-%dT%I:%M:%S%z").should eql('2013-02-21T02:15:14+0000')
    end

    it "should give nil if the updated tag does not exist" do
      @poco_empty.updated.should eql(nil)
    end
  end

  describe "#birthday" do
    it "should give a Date instance" do
      @poco.birthday.class.should eql(Date)
    end

    it "should give a Date containing the content of the birthday tag" do
      @poco.birthday.strftime("%Y-%m-%d").should eql('2014-02-21')
    end

    it "should give nil if the birthday tag does not exist" do
      @poco_empty.birthday.should eql(nil)
    end
  end

  describe "#anniversary" do
    it "should give a Date instance" do
      @poco.anniversary.class.should eql(Date)
    end

    it "should give a Date containing the content of the anniversary tag" do
      @poco.anniversary.strftime("%Y-%m-%d").should eql('2015-02-21')
    end

    it "should give nil if the anniversary tag does not exist" do
      @poco_empty.anniversary.should eql(nil)
    end
  end

  describe "#gender" do
    it "should give a String containing the content of the gender tag" do
      @poco.gender.should eql('male')
    end

    it "should give nil if the gender tag does not exist" do
      @poco_empty.gender.should eql(nil)
    end
  end

  describe "#note" do
    it "should give a String containing the content of the note tag" do
      @poco.note.should eql("foo\nbar")
    end

    it "should give nil if the note tag does not exist" do
      @poco_empty.note.should eql(nil)
    end
  end

  describe "#preferred_username" do
    it "should give a String containing the content of the preferred_username tag" do
      @poco.preferred_username.should eql("greenmanspirit")
    end

    it "should give nil if the preferred_username tag does not exist" do
      @poco_empty.preferred_username.should eql(nil)
    end
  end

  describe "#connected" do
    it "should give a boolean true when the content of the connected tag is 'true'" do
      @poco.connected.should eql(true)
    end

    it "should give a boolean false when the content of the connected tag is 'false'" do
      @poco_false.connected.should eql(false)
    end

    it "should give nil if the connected tag does not exist" do
      @poco_empty.connected.should eql(nil)
    end
  end
end
