require_relative 'helper'
require_relative '../lib/ostatus/salmon.rb'

describe OStatus::Notification do
  describe "Notification.from_xml" do
    it "should return nil if source is empty string" do
      OStatus::Notification.from_xml("").must_equal(nil)
    end

    it "should be able to parse the output of to_xml" do
      @user   = OStatus::Author.new(:name => "wilkie")
      @follow = OStatus::Author.new(:name => "wilkie")

      OStatus::Notification.from_xml(OStatus::Notification.from_follow(@user, @follow).to_xml)
    end
  end

  describe "Notification.from_unfollow" do
    before do
      @user   = OStatus::Author.new(:name => "wilkie")
      @follow = OStatus::Author.new(:name => "wilkie")
      @salmon = OStatus::Notification.from_unfollow(@user, @follow)
    end

    it "should create a new Notification representing the given user author" do
      @salmon.entry.author.must_equal @user
    end

    it "should create a new Notification representing the given user author" do
      @salmon.entry.activity.object.must_equal @follow
    end
  end

  describe "Notification.from_follow" do
    before do
      @user   = OStatus::Author.new(:name => "wilkie")
      @follow = OStatus::Author.new(:name => "wilkie")
      @salmon = OStatus::Notification.from_follow(@user, @follow)
    end

    it "should create a new Notification representing the given user author" do
      @salmon.entry.author.must_equal @user
    end

    it "should create a new Notification representing the given user author" do
      @salmon.entry.activity.object.must_equal @follow
    end
  end

  describe "Notification.from_profile_update" do
    before do
      @user   = OStatus::Author.new(:name => "wilkie")
      @salmon = OStatus::Notification.from_profile_update(@user)
    end

    it "should create a new Notification representing the given user author" do
      @salmon.entry.author.must_equal @user
    end
  end
end
