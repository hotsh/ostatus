# OStatus

This gem implements the OStatus protocol which lets your website connect and interact with any website implementing this protocol.
Users of an OStatus enabled site can communicate, produce and consume with users of all OStatus sites as one large community while also allowing them
to host such websites on their own servers or choice of hosting provider.
Specifically, this gem deals with handling the data streams and the technologies that are related to OStatus such as ActivityStreams, PortableContacts, Webfinger, PubSubHubbub, and Salmon.

One such application of this library is [rstat.us](https://rstat.us), which is a Twitter-like service that you can host yourself.

## Usage

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

## Object Documentation

### Feed

The Feed is the aggregate. It holds a collection of entries written by a set of authors or contributors. It's the container for content.

#### Usage

```
author = OStatus::Author.new(:name => "Kelly")
feed = OStatus::Feed.new(:title   => "My Feed",
                         :id      => "1",
                         :url     => "http://example.com/feeds/1",
                         :authors => [author])
```

#### Fields
```
id            => The unique identifier for this feed.
url           => The url that represents this feed.
title         => The title for this feed. Defaults: "Untitled"
title_type    => The content type for the title.
subtitle      => The subtitle for this feed.
subtitle_type => The content type for the subtitle.
authors       => The list of OStatus::Author's for this feed.
                 Defaults: []
contributors  => The list of OStatus::Author's that contributed to this
                 feed. Defaults: []
entries       => The list of OStatus::Entry's for this feed.
                 Defaults: []
icon          => The url of the icon that represents this feed. It
                 should have an aspect ratio of 1 horizontal to 1
                 vertical and optimized for presentation at a
                 small size.
logo          => The url of the logo that represents this feed. It
                 should have an aspect ratio of 2 horizontal to 1
                 vertical.
categories    => An array of OStatus::Category's that describe how to
                 categorize and describe the content of the feed.
                 Defaults: []
rights        => A String depicting the rights of entries without
                 explicit rights of their own. SHOULD NOT be machine
                 interpreted.
updated       => The DateTime representing when this feed was last
                 modified.
published     => The DateTime representing when this feed was originally
                 published.
salmon_url    => The url of the salmon endpoint, if one exists, for this
                 feed.
links         => An array of OStatus::Link that adds relations to other
                 resources.
generator     => An OStatus::Generator representing the agent
                 responsible for generating this feed.
```

### Entry

The entry is the content. It typically has an author and it represents some type of object.

#### Usage
```
entry = OStatus::Entry.new(:activity => :note,
                           :title => "wilkie's Daily Update",
                           :content => "My day is going really well!",
                           :id => "123",
                           :url => "http://example.com/entries/123")
```

#### Fields
```
:title        => The title of the entry. Defaults: "Untitled"
:author       => A OStatus::Author responsible for generating this entry.
:content      => The content of the entry. Defaults: ""
:content_type => The MIME type of the content.
:published    => The DateTime depicting when the entry was originally
                 published.
:updated      => The DateTime depicting when the entry was modified.
:url          => The canonical url of the entry.
:id           => The unique id that identifies this entry.
:activity     => The activity this entry represents. Either a single string
                 denoting what type of object this entry represents, or an
                 entire OStatus::Activity when a more detailed description is
                 appropriate.
:in_reply_to  => An array of OStatus::Thread that this entry is a
                 response to. Use this when this Entry is a reply
                 to an existing Entry.
```

### Author


## TODO

* General cleanup and abstraction of elements of Atom et al that aren't very consistent or useful.
* Add a persistence layer and allow this to be mixed with Rails and Sinatra style models.
* Add rails/sinatra aides to allow rapid development of OStatus powered websites.
* Add already written osub/opub functionality to allow this gem to subscribe directly to other OStatus powered websites.
* Add Webfinger user identity and verification written in the Salmon library and pull the remaining logic out of rstat.us.
* Add JSON backend.
* Write a PuSH hub to aid in small-scale deployment. (Possibly as a detached project. OStatus talks to the hub via a socket.)
