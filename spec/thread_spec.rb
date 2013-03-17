require_relative 'helper'
require_relative '../lib/ostatus/thread.rb'

describe OStatus::Thread do
  describe "#initialize" do
    it "should store an ref" do
      OStatus::Thread.new(:ref => "object").ref.must_equal "object"
    end

    it "should store an type" do
      OStatus::Thread.new(:type => "html").type.must_equal "html"
    end

    it "should store a href" do
      OStatus::Thread.new(:href => "http://example.com").href.must_equal "http://example.com"
    end

    it "should store a source" do
      OStatus::Thread.new(:source => "http://example.com").source.must_equal "http://example.com"
    end
  end
end
