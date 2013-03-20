require_relative 'helper'
require_relative '../lib/ostatus/entry.rb'

describe OStatus::Entry do
  describe "#initialize" do
    it "should store a title" do
      OStatus::Entry.new(:title => "My Title").title.must_equal "My Title"
    end

    it "should store an author" do
      author = mock('author')
      OStatus::Entry.new(:author => author).author.must_equal author
    end

    it "should store content" do
      OStatus::Entry.new(:content => "Hello").content.must_equal "Hello"
    end

    it "should store the content type" do
      OStatus::Entry.new(:content_type => "txt").content_type.must_equal "txt"
    end

    it "should store the published date" do
      time = mock('date')
      OStatus::Entry.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('date')
      OStatus::Entry.new(:updated => time).updated.must_equal time
    end

    it "should store a source feed" do
      feed = mock('feed')
      OStatus::Entry.new(:source => feed).source.must_equal feed
    end

    it "should store a url" do
      OStatus::Entry.new(:url => "url").url.must_equal "url"
    end

    it "should store an id" do
      OStatus::Entry.new(:id => "id").id.must_equal "id"
    end

    it "should store an activity when given a string" do
      activity = mock('activity')
      OStatus::Activity.expects(:new).with(has_entry(:object_type => "note")).returns(activity)
      OStatus::Entry.new(:activity => "note").activity.must_equal activity
    end

    it "should store an activity when given a symbol" do
      activity = mock('activity')
      OStatus::Activity.expects(:new).with(has_entry(:object_type => :note)).returns(activity)
      OStatus::Entry.new(:activity => :note).activity.must_equal activity
    end

    it "should store an activity" do
      activity = mock('activity')
      OStatus::Entry.new(:activity => activity).activity.must_equal activity
    end

    it "should store an array of threads" do
      thread = mock('entry')
      OStatus::Entry.new(:in_reply_to => [thread]).in_reply_to.must_equal [thread]
    end

    it "should store an array of threads when only given one entry" do
      thread = mock('entry')
      OStatus::Entry.new(:in_reply_to => thread).in_reply_to.must_equal [thread]
    end

    it "should store an empty array of threads by default" do
      OStatus::Entry.new.in_reply_to.must_equal []
    end

    it "should default the content to '' if not given" do
      OStatus::Entry.new.content.must_equal ''
    end

    it "should default the title to 'Untitled' if not given" do
      OStatus::Entry.new.title.must_equal "Untitled"
    end
  end

  describe "#to_link" do
    it "should return a OStatus::Link" do
      link = mock('link')
      OStatus::Link.stubs(:new).returns(link)
      OStatus::Entry.new.to_link.must_equal link
    end

    it "should by default use the title of the feed" do
      OStatus::Link.expects(:new).with(has_entry(:title, "title"))
      OStatus::Entry.new(:title => "title").to_link
    end

    it "should by default use the url of the feed as the href" do
      OStatus::Link.expects(:new).with(has_entry(:href, "http://example.com"))
      OStatus::Entry.new(:url => "http://example.com").to_link
    end

    it "should override the title of the feed when given" do
      OStatus::Link.expects(:new).with(has_entry(:title, "new title"))
      OStatus::Entry.new(:title => "title").to_link(:title => "new title")
    end

    it "should override the url of the feed when given" do
      OStatus::Link.expects(:new).with(has_entry(:url, "http://feeds.example.com"))
      OStatus::Entry.new(:url => "http://example.com")
        .to_link(:url => "http://feeds.example.com")
    end

    it "should pass through the rel option" do
      OStatus::Link.expects(:new).with(has_entry(:rel, "alternate"))
      OStatus::Entry.new.to_link(:rel => "alternate")
    end

    it "should pass through the hreflang option" do
      OStatus::Link.expects(:new).with(has_entry(:hreflang, "en_us"))
      OStatus::Entry.new.to_link(:hreflang => "en_us")
    end

    it "should pass through the length option" do
      OStatus::Link.expects(:new).with(has_entry(:length, 12345))
      OStatus::Entry.new.to_link(:length => 12345)
    end

    it "should pass through the type option" do
      OStatus::Link.expects(:new).with(has_entry(:type, "html"))
      OStatus::Entry.new.to_link(:type => "html")
    end
  end

  describe "#info" do
    it "should return a Hash containing the title" do
      OStatus::Entry.new(:title => "My Title")
        .to_hash[:title].must_equal "My Title"
    end

    it "should return a Hash containing the author" do
      author = mock('author')
      OStatus::Entry.new(:author => author)
        .to_hash[:author].must_equal author
    end

    it "should return a Hash containing the content" do
      OStatus::Entry.new(:content => "Hello")
        .to_hash[:content].must_equal "Hello"
    end

    it "should return a Hash containing the content-type" do
      OStatus::Entry.new(:content_type => "txt")
        .to_hash[:content_type].must_equal "txt"
    end

    it "should return a Hash containing the published date" do
      time = mock('date')
      OStatus::Entry.new(:published => time)
        .to_hash[:published].must_equal time
    end

    it "should return a Hash containing the updated date" do
      time = mock('date')
      OStatus::Entry.new(:updated => time)
        .to_hash[:updated].must_equal time
    end

    it "should return a Hash containing the url" do
      OStatus::Entry.new(:url => "url")
        .to_hash[:url].must_equal "url"
    end

    it "should return a Hash containing the source" do
      feed = mock('feed')
      OStatus::Entry.new(:source => feed)
        .to_hash[:source].must_equal feed
    end

    it "should return a Hash containing the id" do
      OStatus::Entry.new(:id => "id")
        .to_hash[:id].must_equal "id"
    end

    it "should return a Hash containing the activity" do
      activity = mock('activity')
      OStatus::Entry.new(:activity => activity)
        .to_hash[:activity].must_equal activity
    end
  end

  describe "#to_atom" do
    it "should relegate atom generation to Atom::Entry" do
      atom_entry = mock('atom')
      atom_entry.expects(:to_xml).returns("ATOM")

      require_relative '../lib/ostatus/atom/entry.rb'

      OStatus::Atom::Entry.stubs(:new).returns(atom_entry)

      OStatus::Entry.new(:title => "foo").to_atom.must_equal "ATOM"
    end
  end
end
