require_relative 'helper'
require_relative '../lib/ostatus/author.rb'

describe OStatus::Author do
  describe "#initialize" do
    it "should store an uri" do
      OStatus::Author.new(:uri => "http://example.com/1").uri.must_equal "http://example.com/1"
    end

    it "should store a name" do
      OStatus::Author.new(:name => "foo").name.must_equal "foo"
    end

    it "should store a email" do
      OStatus::Author.new(:email => "foo@example.com").email.must_equal "foo@example.com"
    end

    it "should store a id" do
      OStatus::Author.new(:id => "1").id.must_equal "1"
    end

    it "should store a gender" do
      OStatus::Author.new(:gender => "androgynous").gender.must_equal "androgynous"
    end

    it "should store nickname" do
      OStatus::Author.new(:nickname => "foobar").nickname.must_equal "foobar"
    end

    it "should store the display name" do
      OStatus::Author.new(:display_name => "foobar").display_name.must_equal "foobar"
    end

    it "should store the preferred username" do
      OStatus::Author.new(:preferred_username => "foobar")
        .preferred_username.must_equal "foobar"
    end

    it "should store the birthday" do
      time = mock('datetime')
      OStatus::Author.new(:birthday => time).birthday.must_equal time
    end

    it "should store the anniversary" do
      time = mock('datetime')
      OStatus::Author.new(:anniversary => time).anniversary.must_equal time
    end

    it "should store the note" do
      OStatus::Author.new(:note => "note").note.must_equal "note"
    end

    it "should store the published date" do
      time = mock('datetime')
      OStatus::Author.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('datetime')
      OStatus::Author.new(:updated => time).updated.must_equal time
    end

    it "should store an address hash" do
      address = mock('hash')
      OStatus::Author.new(:address => address).address.must_equal address
    end

    it "should store an organization hash" do
      organization = mock('hash')
      OStatus::Author.new(:organization => organization).organization.must_equal organization
    end

    it "should store an extended name hash" do
      name = mock('hash')
      OStatus::Author.new(:extended_name => name).extended_name.must_equal name
    end

    it "should store an account hash" do
      account = mock('hash')
      OStatus::Author.new(:account => account).account.must_equal account
    end
  end

  describe "#to_hash" do
    it "should return a Hash containing the id" do
      OStatus::Author.new(:id => "1").to_hash[:id].must_equal "1"
    end

    it "should return a Hash containing the gender" do
      OStatus::Author.new(:gender => "androgynous").to_hash[:gender].must_equal "androgynous"
    end

    it "should return a Hash containing nickname" do
      OStatus::Author.new(:nickname => "foobar").to_hash[:nickname].must_equal "foobar"
    end

    it "should return a Hash containing the display name" do
      OStatus::Author.new(:display_name => "foobar").display_name.must_equal "foobar"
    end

    it "should return a Hash containing the preferred username" do
      OStatus::Author.new(:preferred_username => "foobar")
        .preferred_username.must_equal "foobar"
    end

    it "should return a Hash containing the birthday" do
      time = mock('datetime')
      OStatus::Author.new(:birthday => time).to_hash[:birthday].must_equal time
    end

    it "should return a Hash containing the anniversary" do
      time = mock('datetime')
      OStatus::Author.new(:anniversary => time).to_hash[:anniversary].must_equal time
    end

    it "should return a Hash containing the note" do
      OStatus::Author.new(:note => "note").to_hash[:note].must_equal "note"
    end

    it "should return a Hash containing the published date" do
      time = mock('datetime')
      OStatus::Author.new(:published => time).to_hash[:published].must_equal time
    end

    it "should return a Hash containing the updated date" do
      time = mock('datetime')
      OStatus::Author.new(:updated => time).to_hash[:updated].must_equal time
    end

    it "should return a Hash containing the address hash" do
      address = mock('hash')
      OStatus::Author.new(:address => address).to_hash[:address].must_equal address
    end

    it "should return a Hash containing the organization hash" do
      organization = mock('hash')
      OStatus::Author.new(:organization => organization).to_hash[:organization].must_equal organization
    end

    it "should return a Hash containing the extended name hash" do
      name = mock('hash')
      OStatus::Author.new(:extended_name => name).to_hash[:extended_name].must_equal name
    end

    it "should return a Hash containing the account hash" do
      account = mock('hash')
      OStatus::Author.new(:account => account).to_hash[:account].must_equal account
    end
  end
end
