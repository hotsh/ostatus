require_relative 'ostatus/feed'
require_relative 'ostatus/entry'
require_relative 'ostatus/author'
require_relative 'ostatus/activity'
require_relative 'ostatus/portable_contacts'
require_relative 'ostatus/salmon'
require_relative 'ostatus/thread'
require_relative 'ostatus/link'

# This module contains individual elements of the OStatus protocol. It also
# contains methods to construct these objects from external sources.
module OStatus
  # Will yield a OStatus::Feed object representing the feed at the given url.
  def from_feed_url
  end
end
