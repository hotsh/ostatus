require_relative 'helper'
require_relative '../lib/ostatus/portable_contacts.rb'

describe OStatus::PortableContacts do
  describe "#initialize" do
    it "should store a id" do
      OStatus::PortableContacts.new(:id => "1").id.must_equal "1"
    end

    it "should store a gender" do
      OStatus::PortableContacts.new(:gender => "androgynous").gender.must_equal "androgynous"
    end

    it "should store nickname" do
      OStatus::PortableContacts.new(:nickname => "foobar").nickname.must_equal "foobar"
    end

    it "should store the display name" do
      OStatus::PortableContacts.new(:display_name => "foobar").display_name.must_equal "foobar"
    end

    it "should store the preferred username" do
      OStatus::PortableContacts.new(:preferred_username => "foobar")
        .preferred_username.must_equal "foobar"
    end

    it "should store the birthday" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:birthday => time).birthday.must_equal time
    end

    it "should store the anniversary" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:anniversary => time).anniversary.must_equal time
    end

    it "should store the note" do
      OStatus::PortableContacts.new(:note => "note").note.must_equal "note"
    end

    it "should store the published date" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:published => time).published.must_equal time
    end

    it "should store the updated date" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:updated => time).updated.must_equal time
    end

    it "should store an address hash" do
      address = mock('hash')
      OStatus::PortableContacts.new(:address => address).address.must_equal address
    end

    it "should store an organization hash" do
      organization = mock('hash')
      OStatus::PortableContacts.new(:organization => organization).organization.must_equal organization
    end

    it "should store a name hash" do
      name = mock('hash')
      OStatus::PortableContacts.new(:name => name).name.must_equal name
    end

    it "should store an account hash" do
      account = mock('hash')
      OStatus::PortableContacts.new(:account => account).account.must_equal account
    end
  end

  describe "#to_hash" do
    it "should return a Hash containing the id" do
      OStatus::PortableContacts.new(:id => "1").to_hash[:id].must_equal "1"
    end

    it "should return a Hash containing the gender" do
      OStatus::PortableContacts.new(:gender => "androgynous").to_hash[:gender].must_equal "androgynous"
    end

    it "should return a Hash containing nickname" do
      OStatus::PortableContacts.new(:nickname => "foobar").to_hash[:nickname].must_equal "foobar"
    end

    it "should return a Hash containing the display name" do
      OStatus::PortableContacts.new(:display_name => "foobar").display_name.must_equal "foobar"
    end

    it "should return a Hash containing the preferred username" do
      OStatus::PortableContacts.new(:preferred_username => "foobar")
        .preferred_username.must_equal "foobar"
    end

    it "should return a Hash containing the birthday" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:birthday => time).to_hash[:birthday].must_equal time
    end

    it "should return a Hash containing the anniversary" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:anniversary => time).to_hash[:anniversary].must_equal time
    end

    it "should return a Hash containing the note" do
      OStatus::PortableContacts.new(:note => "note").to_hash[:note].must_equal "note"
    end

    it "should return a Hash containing the published date" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:published => time).to_hash[:published].must_equal time
    end

    it "should return a Hash containing the updated date" do
      time = mock('datetime')
      OStatus::PortableContacts.new(:updated => time).to_hash[:updated].must_equal time
    end

    it "should return a Hash containing the address hash" do
      address = mock('hash')
      OStatus::PortableContacts.new(:address => address).to_hash[:address].must_equal address
    end

    it "should return a Hash containing the organization hash" do
      organization = mock('hash')
      OStatus::PortableContacts.new(:organization => organization).to_hash[:organization].must_equal organization
    end

    it "should return a Hash containing the name hash" do
      name = mock('hash')
      OStatus::PortableContacts.new(:name => name).to_hash[:name].must_equal name
    end

    it "should return a Hash containing the account hash" do
      account = mock('hash')
      OStatus::PortableContacts.new(:account => account).to_hash[:account].must_equal account
    end
  end
end
