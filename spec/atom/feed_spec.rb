require_relative '../helper'
require_relative '../../lib/ostatus/feed.rb'
require_relative '../../lib/ostatus/atom/feed.rb'

# Sanity checks on atom generation because I don't trust ratom completely.

describe OStatus::Atom do
  before do
    poco = OStatus::PortableContacts.new(:id => "1",
                                         :nickname    => "wilkie",
                                         :name        => {:formatted => "Dave Wilkinson",
                                                          :family_name => "Wilkinson",
                                                          :given_name => "Dave",
                                                          :middle_name => "William",
                                                          :honorific_prefix => "Mr.",
                                                          :honorific_suffix => "II"},
                                         :address => {:formatted => "123 Cherry Lane\nFoobar, PA, USA\n15206",
                                                      :street_address => "123 Cherry Lane",
                                                      :locality => "Foobar",
                                                      :region => "PA",
                                                      :postal_code => "15206",
                                                      :country => "USA"},
                                         :organization => {:name => "Hackers of the Severed Hand",
                                                           :department => "Making Shit",
                                                           :title => "Founder",
                                                           :type => "open source",
                                                           :start_date => Date.today,
                                                           :end_date => Date.today,
                                                           :location => "everywhere",
                                                           :description => "I make ostatus work"},
                                         :account     => {:domain => "example.com",
                                                         :username => "wilkie",
                                                         :userid => "1"},
                                         :gender      => "androgynous",
                                         :note        => "cool dude",
                                         :display_name => "Dave Wilkinson",
                                         :preferred_username => "wilkie",
                                         :updated     => Time.now,
                                         :published   => Time.now,
                                         :birthday    => Date.today,
                                         :anniversary => Date.today)

    author = OStatus::Author.new(:uri               => "http://example.com/users/1",
                                 :email             => "user@example.com",
                                 :portable_contacts => poco,
                                 :name              => "wilkie")

    @master = OStatus::Feed.new(:title => "My Feed",
                                :title_type => "html",
                                :subtitle => "Subtitle",
                                :subtitle_type => "html",
                                :url => "http://example.com/feeds/1",
                                :rights => "CC0",
                                :icon => "http://example.com/icon.png",
                                :logo => "http://example.com/logo.png",
                                :hubs => ["http://hub.example.com",
                                          "http://hub2.example.com"],
                                :published => Time.now,
                                :updated => Time.now,
                                :authors => [author],
                                :id => "12345")
  end

  it "should be able to reform canonical structure using Atom" do
    xml = OStatus::Atom::Feed.from_canonical(@master).to_xml
    new_feed = OStatus::Atom::Feed.new(XML::Reader.string(xml)).to_canonical

    old_hash = @master.to_hash
    new_hash = new_feed.to_hash

    old_hash[:authors] = old_hash[:authors].map(&:to_hash)
    new_hash[:authors] = new_hash[:authors].map(&:to_hash)

    old_hash[:authors].each {|a| a[:portable_contacts] = a[:portable_contacts].to_hash}
    new_hash[:authors].each {|a| a[:portable_contacts] = a[:portable_contacts].to_hash}

    # Flatten all keys to their to_s
    # We want to compare the to_s for all keys
    def flatten_keys!(hash)
      hash.keys.each do |k|
        if hash[k].is_a? Array
          # Go inside arrays (doesn't handle arrays of arrays)
          hash[k].map! do |e|
            if e.is_a? Hash
              flatten_keys! e
              e
            else
              e.to_s
            end
          end
        elsif hash[k].is_a? Hash
          # Go inside hashes
          flatten_keys!(hash[k])
        elsif hash[k].is_a? Time
          # Ensure all Time classes become DateTimes for comparison
          hash[k] = hash[k].to_datetime.to_s
        else
          # Ensure all fields become Strings
          hash[k] = hash[k].to_s
        end
      end
    end

    flatten_keys!(old_hash)
    flatten_keys!(new_hash)

    old_hash.must_equal new_hash
  end

  describe "<xml>" do
    before do
      @xml_str = OStatus::Atom::Feed.from_canonical(@master).to_xml
      @xml = XML::Parser.string(@xml_str).parse
    end

    it "should publish a version of 1.0" do
      @xml_str.must_match /^<\?xml[^>]*\sversion="1\.0"/
    end

    it "should encode in utf-8" do
      @xml_str.must_match /^<\?xml[^>]*\sencoding="UTF-8"/
    end

    describe "<feed>" do
      before do
        @feed = @xml.root
      end

      it "should contain the Atom namespace" do
        @feed.namespaces.find_by_href("http://www.w3.org/2005/Atom").to_s
          .must_equal "http://www.w3.org/2005/Atom"
      end

      it "should contain the PortableContacts namespace" do
        @feed.namespaces.find_by_prefix('poco').to_s
          .must_equal "poco:http://portablecontacts.net/spec/1.0"
      end

      it "should contain the ActivityStreams namespace" do
        @feed.namespaces.find_by_prefix('activity').to_s
          .must_equal "activity:http://activitystrea.ms/spec/1.0/"
      end

      describe "<id>" do
        it "should contain the id from OStatus::Feed" do
          @feed.find_first('xmlns:id', 'xmlns:http://www.w3.org/2005/Atom')
            .content.must_equal @master.id
        end
      end

      describe "<rights>" do
        it "should contain the rights from OStatus::Feed" do
          @feed.find_first('xmlns:rights', 'xmlns:http://www.w3.org/2005/Atom')
            .content.must_equal @master.rights
        end
      end

      describe "<logo>" do
        it "should contain the logo from OStatus::Feed" do
          @feed.find_first('xmlns:logo', 'xmlns:http://www.w3.org/2005/Atom')
            .content.must_equal @master.logo
        end
      end

      describe "<icon>" do
        it "should contain the icon from OStatus::Feed" do
          @feed.find_first('xmlns:icon', 'xmlns:http://www.w3.org/2005/Atom')
            .content.must_equal @master.icon
        end
      end

      describe "<published>" do
        it "should contain the time in the published field in OStatus::Feed" do
          time = @feed.find_first('xmlns:published',
                                  'xmlns:http://www.w3.org/2005/Atom').content
          DateTime::rfc3339(time).to_s.must_equal @master.published.to_datetime.to_s
        end
      end

      describe "<updated>" do
        it "should contain the time in the updated field in OStatus::Feed" do
          time = @feed.find_first('xmlns:updated',
                                  'xmlns:http://www.w3.org/2005/Atom').content
          DateTime::rfc3339(time).to_s.must_equal @master.updated.to_datetime.to_s
        end
      end

      describe "<link>" do
        it "should contain a link for the hub" do
          @feed.find_first('xmlns:link[@rel="hub"]',
                           'xmlns:http://www.w3.org/2005/Atom').attributes
             .get_attribute('href').value.must_equal(@master.hubs.first)
        end

        it "should allow a second link for the hub" do
          @feed.find('xmlns:link[@rel="hub"]',
                     'xmlns:http://www.w3.org/2005/Atom')[1].attributes
             .get_attribute('href').value.must_equal(@master.hubs[1])
        end

        it "should contain a link for self" do
          @feed.find_first('xmlns:link[@rel="self"]',
                           'xmlns:http://www.w3.org/2005/Atom').attributes
             .get_attribute('href').value.must_equal(@master.url)
        end
      end

      describe "<title>" do
        before do
          @title = @feed.find_first('xmlns:title', 'xmlns:http://www.w3.org/2005/Atom')
        end

        it "should contain the title from OStatus::Feed" do
          @title.content.must_equal @master.title
        end

        it "should contain the type attribute from OStatus::Feed" do
          @title.attributes.get_attribute('type').value.must_equal @master.title_type
        end
      end

      describe "<subtitle>" do
        before do
          @subtitle = @feed.find_first('xmlns:subtitle', 'xmlns:http://www.w3.org/2005/Atom')
        end

        it "should contain the subtitle from OStatus::Feed" do
          @subtitle.content.must_equal @master.subtitle
        end

        it "should contain the type attribute from OStatus::Feed" do
          @subtitle.attributes.get_attribute('type').value.must_equal @master.subtitle_type
        end
      end
    end
  end
end
