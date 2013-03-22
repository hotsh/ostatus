require_relative 'helper'
require_relative '../lib/ostatus/identity.rb'

describe OStatus::Feed do
  describe "#initialize" do
    it "should store a public_key" do
      OStatus::Identity.new(:public_key => "key").public_key.must_equal "key"
    end

    it "should store a salmon endpoint" do
      OStatus::Identity.new(:salmon_endpoint => "url").salmon_endpoint
        .must_equal "url"
    end

    it "should store a dialback endpoint" do
      OStatus::Identity.new(:dialback_endpoint => "url").dialback_endpoint
        .must_equal "url"
    end

    it "should store a activity inbox endpoint" do
      OStatus::Identity.new(:activity_inbox_endpoint => "url")
        .activity_inbox_endpoint.must_equal "url"
    end

    it "should store a activity outbox endpoint" do
      OStatus::Identity.new(:activity_outbox_endpoint => "url")
        .activity_outbox_endpoint.must_equal "url"
    end

    it "should store a profile page" do
      OStatus::Identity.new(:profile_page => "url").profile_page
        .must_equal "url"
    end
  end

  describe "#to_hash" do
    it "should return a Hash with the public_key" do
      OStatus::Identity.new(:public_key => "key")
        .to_hash[:public_key].must_equal "key"
    end

    it "should return a Hash with the salmon endpoint" do
      OStatus::Identity.new(:salmon_endpoint => "url")
        .to_hash[:salmon_endpoint].must_equal "url"
    end

    it "should return a Hash with the dialback endpoint" do
      OStatus::Identity.new(:dialback_endpoint => "url")
        .to_hash[:dialback_endpoint].must_equal "url"
    end

    it "should return a Hash with the activity inbox endpoint" do
      OStatus::Identity.new(:activity_inbox_endpoint => "url")
        .to_hash[:activity_inbox_endpoint].must_equal "url"
    end

    it "should return a Hash with the activity outbox endpoint" do
      OStatus::Identity.new(:activity_outbox_endpoint => "url")
        .to_hash[:activity_outbox_endpoint].must_equal "url"
    end

    it "should return a Hash with the profile page" do
      OStatus::Identity.new(:profile_page => "url")
        .to_hash[:profile_page].must_equal "url"
    end
  end
end
