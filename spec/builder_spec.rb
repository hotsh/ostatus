require_relative '../lib/ostatus/feed.rb'

describe 'XML builder' do
  before(:each) do
    @feed_url = 'http://example.org/feed'
    @poco     = OStatus::PortableContacts.new(:id => '68b329da9893e34099c7d8ad5cb9c940',
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
                                    :entries => [])
    puts @feed.atom
  end

  it 'should generate the title' do
    @feed.atom.should match(/<title>Dean's Updates/)
  end

  it 'should generate the id' do
    @feed.atom.should match(/<id>#{@feed_url}/)
  end

  it 'should generate the author' do
    @feed.atom.should match(/<name>Dean Venture/)
  end
end
