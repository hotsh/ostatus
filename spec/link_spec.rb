require_relative 'helper'
require_relative '../lib/ostatus/link.rb'

describe OStatus::Link do
  describe "#initialize" do
    it "should store an href" do
      OStatus::Link.new(:href => "object").href.must_equal "object"
    end

    it "should store an type" do
      OStatus::Link.new(:type => "html").type.must_equal "html"
    end

    it "should store a hreflang" do
      OStatus::Link.new(:hreflang => :follow).hreflang.must_equal :follow
    end

    it "should store a title" do
      OStatus::Link.new(:title => "Title").title.must_equal "Title"
    end

    it "should store a rel" do
      OStatus::Link.new(:rel => "alternate").rel.must_equal "alternate"
    end

    it "should store a length" do
      OStatus::Link.new(:length => 12345).length.must_equal 12345
    end
  end
end
