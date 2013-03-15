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

    it "should store a url" do
      OStatus::Entry.new(:url => "url").url.must_equal "url"
    end

    it "should store an id" do
      OStatus::Entry.new(:id => "id").id.must_equal "id"
    end

    it "should store an activity" do
      activity = mock('activity')
      OStatus::Entry.new(:activity => activity).activity.must_equal activity
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
