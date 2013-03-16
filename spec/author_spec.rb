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

    it "should store a PortableContacts" do
      poco = mock('portable_contacts')
      OStatus::Author.new(:portable_contacts => poco).portable_contacts.must_equal poco
    end
  end
end
