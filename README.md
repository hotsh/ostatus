OStatus
=======

This gem implements the OStatus protocol which lets your website connect and interact with any website implementing this protocol.
Users of an OStatus enabled site can communicate, produce and consume with users of all OStatus sites as one large community while also allowing them
to host such websites on their own servers or choice of hosting provider.
Specifically, this gem deals with handling the data streams and the technologies that are related to OStatus such as ActivityStreams, PortableContacts, Webfinger, PubSubHubbub, and Salmon.

One such application of this library is [rstat.us](https://rstat.us), which is a Twitter-like service that you can host yourself.

Usage
------------

Currently, only the immutable interface is available.

```
require 'ostatus'

author = OStatus::Author.new(:uri   => "https://rstat.us/users/wilkie",
                             :email => "wilkie@xomb.org",
                             :name  => "wilkie")

blog_post = OStatus::Entry.new(:activity => :post,
                               :title => "OStatus gem",
                               :author => author,
                               :content => "Long blog post",
                               :content_type => "text/html",
                               :id => "1",
                               :uri => "http://blog.davewilkinsonii.com/posts/ostatus_gem",
                               :published => Time.now)

feed = OStatus::Feed.new(:title => "wilkie writes a thing",
                         :url => "http://blog.davewilkinsonii.com",
                         :rights => "CC0",
                         :hubs => ["http://hub.davewilkinsonii.com"],
                         :authors => [author],
                         :published => Time.now,
                         :entries => [blog_post])
```

To generate an Atom representation:

```
feed.to_atom
```

To generate a collection of OStatus objects from Atom:

```
OStatus.feed_from_url("https://rstat.us/users/wilkieii/feed")
```

TODO
----

* Add a persistence layer and allow this to be mixed with Rails and Sinatra style models.
* Add rails/sinatra aides to allow rapid development of OStatus powered websites.
* Add already written osub/opub functionality to allow this gem to subscribe directly to other OStatus powered websites.
* Add Webfinger user identity and verification written in the Salmon library and pull the remaining logic out of rstat.us.
* Add JSON backend.
* Write a PuSH hub to aid in small-scale deployment. (Possibly as a detached project. OStatus talks to the hub via a socket.)
