require_relative 'helper'
require_relative '../lib/ostatus/feed.rb'

describe OStatus::Feed do
  describe "#initialize" do
    it "should store a title" do
      OStatus::Feed.new(:title => "My Title").title.must_equal "My Title"
    end

    it "should store a list of authors" do
      author = mock('author')
      OStatus::Feed.new(:authors => [author]).authors.must_equal [author]
    end

    it "should store a list of contributors" do
      author = mock('author')
      OStatus::Feed.new(:contributors => [author]).contributors.must_equal [author]
    end

    it "should store a list of entries" do
      entry = mock('entry')
      OStatus::Feed.new(:entries => [entry]).entries.must_equal [entry]
    end

    it "should store a list of hubs" do
      OStatus::Feed.new(:hubs => ["http://hub.example.com"]).hubs
        .must_equal ["http://hub.example.com"]
    end

    it "should store the id of the feed" do
      OStatus::Feed.new(:id => "id").id.must_equal "id"
    end

    it "should store the icon for the feed" do
      OStatus::Feed.new(:icon => "url").icon.must_equal "url"
    end

    it "should store the url for the feed" do
      OStatus::Feed.new(:url => "url").url.must_equal "url"
    end

    it "should store the published date" do
      time = mock('date')
      OStatus::Feed.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('date')
      OStatus::Feed.new(:updated => time).updated.must_equal time
    end

    it "should store the salmon url for the feed" do
      OStatus::Feed.new(:salmon_url => "url").salmon_url.must_equal "url"
    end

    it "should store the generator for the feed" do
      OStatus::Feed.new(:generator => "feedmaker").generator.must_equal "feedmaker"
    end

    it "should yield an empty array for authors by default" do
      OStatus::Feed.new.authors.must_equal []
    end

    it "should yield an empty array for contributors by default" do
      OStatus::Feed.new.contributors.must_equal []
    end

    it "should yield an empty array for entries by default" do
      OStatus::Feed.new.entries.must_equal []
    end

    it "should yield an empty array for hubs by default" do
      OStatus::Feed.new.hubs.must_equal []
    end

    it "should yield a title of 'Untitled' by default" do
      OStatus::Feed.new.title.must_equal "Untitled"
    end
  end

  describe "#to_link" do
    it "should return a OStatus::Link" do
      link = mock('link')
      OStatus::Link.stubs(:new).returns(link)
      OStatus::Feed.new.to_link.must_equal link
    end

    it "should by default use the title of the feed" do
      OStatus::Link.expects(:new).with(has_entry(:title, "title"))
      OStatus::Feed.new(:title => "title").to_link
    end

    it "should by default use the url of the feed as the href" do
      OStatus::Link.expects(:new).with(has_entry(:href, "http://example.com"))
      OStatus::Feed.new(:url => "http://example.com").to_link
    end

    it "should override the title of the feed when given" do
      OStatus::Link.expects(:new).with(has_entry(:title, "new title"))
      OStatus::Feed.new(:title => "title").to_link(:title => "new title")
    end

    it "should override the url of the feed when given" do
      OStatus::Link.expects(:new).with(has_entry(:url, "http://feeds.example.com"))
      OStatus::Feed.new(:url => "http://example.com")
        .to_link(:url => "http://feeds.example.com")
    end

    it "should pass through the rel option" do
      OStatus::Link.expects(:new).with(has_entry(:rel, "alternate"))
      OStatus::Feed.new.to_link(:rel => "alternate")
    end

    it "should pass through the hreflang option" do
      OStatus::Link.expects(:new).with(has_entry(:hreflang, "en_us"))
      OStatus::Feed.new.to_link(:hreflang => "en_us")
    end

    it "should pass through the length option" do
      OStatus::Link.expects(:new).with(has_entry(:length, 12345))
      OStatus::Feed.new.to_link(:length => 12345)
    end

    it "should pass through the type option" do
      OStatus::Link.expects(:new).with(has_entry(:type, "html"))
      OStatus::Feed.new.to_link(:type => "html")
    end
  end

  describe "#to_hash" do
    it "should return a Hash containing the title" do
      OStatus::Feed.new(:title => "My Title").to_hash[:title].must_equal "My Title"
    end

    it "should return a Hash containing a list of authors" do
      author = mock('author')
      OStatus::Feed.new(:authors => [author]).to_hash[:authors].must_equal [author]
    end

    it "should return a Hash containing a list of contributors" do
      author = mock('author')
      OStatus::Feed.new(:contributors => [author]).to_hash[:contributors].must_equal [author]
    end

    it "should return a Hash containing a list of entries" do
      entry = mock('entry')
      OStatus::Feed.new(:entries => [entry]).to_hash[:entries].must_equal [entry]
    end

    it "should return a Hash containing the id of the feed" do
      OStatus::Feed.new(:id => "id").to_hash[:id].must_equal "id"
    end

    it "should return a Hash containing the icon for the feed" do
      OStatus::Feed.new(:icon => "url").to_hash[:icon].must_equal "url"
    end

    it "should return a Hash containing the url for the feed" do
      OStatus::Feed.new(:url => "url").to_hash[:url].must_equal "url"
    end

    it "should return a Hash containing the salmon url for the feed" do
      OStatus::Feed.new(:salmon_url => "url").to_hash[:salmon_url].must_equal "url"
    end

    it "should return a Hash containing the published date" do
      time = mock('date')
      OStatus::Feed.new(:published => time).to_hash[:published].must_equal time
    end

    it "should return a Hash containing the updated date" do
      time = mock('date')
      OStatus::Feed.new(:updated => time).to_hash[:updated].must_equal time
    end

    it "should return a Hash containing the generator" do
      OStatus::Feed.new(:generator => "feedmaker").to_hash[:generator].must_equal "feedmaker"
    end
  end

  describe "#to_atom" do
    it "should relegate Atom generation to OStatus::Atom::Feed" do
      atom_entry = mock('atom')
      atom_entry.expects(:to_xml).returns("ATOM")

      require_relative '../lib/ostatus/atom/feed.rb'

      OStatus::Atom::Feed.stubs(:new).returns(atom_entry)

      OStatus::Feed.new(:title => "foo").to_atom.must_equal "ATOM"
    end
  end
end
