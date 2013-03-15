require 'ostatus/feed'
require 'ostatus/entry'
require 'ostatus/author'
require 'ostatus/activity'
require 'ostatus/portable_contacts'
require 'ostatus/salmon'
require 'ostatus/thread'
require 'ostatus/link'

# This module contains individual elements of the OStatus protocol. It also
# contains methods to construct these objects from external sources.
module OStatus
  # Will yield a OStatus::Feed object representing the feed at the given url.
  def from_feed_url
  end
end
