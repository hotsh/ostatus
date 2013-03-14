require_relative 'helper'
require_relative '../lib/ostatus/feed.rb'

describe 'XML builder' do
  before(:each) do
    @feed_url = 'http://example.org/feed'
    @poco_id  = '68b329da9893e34099c7d8ad5cb9c940'
    @poco     = OStatus::PortableContacts.new(:id => @poco_id,
                                              :display_name => 'Dean Venture',
                                              :preferred_username => 'dean')
    @author   = OStatus::Author.new(:name => 'Dean Venture',
                                    :email => 'dean@venture.com',
                                    :uri => 'http://geocities.com/~dean',
                                    :portable_contacts => @poco)
    @feed = OStatus::Feed.from_data(@feed_url,
                                    :title => "Dean's Updates",
                                    :id => @feed_url,
                                    :author => @author,
                                    :entries => [],
                                    :links => {
                                      :hub => [{:href => 'http://example.org/hub'}]
                                    })
  end

  it 'should generate the title' do
    @feed.atom.must_match("<title>Dean's Updates")
  end

  it 'should generate the id' do
    @feed.atom.must_match("<id>#{@feed_url}")
  end

  it 'should generate a self link' do
    # depending on this attribute order is a really terrible idea, but oh well.
    @feed.atom.must_match("<link rel=\"self\" href=\"#{@feed_url}\"/>")
  end

  it 'should generate the hub link' do
    # depending on this attribute order is a really terrible idea, but oh well.
    @feed.atom.must_match('<link rel="hub" href="http://example.org/hub"/>')
  end

  describe 'when generating the author' do
    specify { @feed.atom.must_match('<name>Dean Venture') }
    specify { @feed.atom.must_match('<email>dean@venture.com') }
    specify { @feed.atom.must_match('<uri>http://geocities.com/~dean') }
    specify { @feed.atom.must_match("<poco:id>#{@poco_id}") }
    specify { @feed.atom.must_match('<poco:displayName>Dean Venture') }
    specify { @feed.atom.must_match('<poco:preferredUsername>dean') }
  end

  describe 'when generating a feed with entries' do
    before do
      @now = Time.now

      @feed.entries << OStatus::Entry.new(
        :title => 'atom powered robots are running amok lol',
        :content => 'atom powered robots are running amok lol',
        :updated => @now,
        :published => @now,
        :id => 'http://example.org/feed/1',
        :link => { :href => 'http://example.org/feed/1' }
      )
    end

    specify { @feed.atom.must_match('<title>atom powered robots') }
    specify { @feed.atom.must_match('<content>atom powered robots') }
    specify { @feed.atom.must_match(/#{Regexp.escape("<updated>#{@now.iso8601}")}/) }
    specify { @feed.atom.must_match(/#{Regexp.escape("<published>#{@now.iso8601}")}/) }
    specify { @feed.atom.must_match('<id>http://example.org/feed/1') }
    specify { @feed.atom.must_match('<link href="http://example.org/feed/1"/>') }
  end
end
