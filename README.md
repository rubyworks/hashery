# Hashery

[![Gem Version](https://img.shields.io/gem/v/hashery.svg?style=flat)](https://rubygems.org/gems/hashery)
[![CI](https://github.com/rubyworks/hashery/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyworks/hashery/actions/workflows/ci.yml)
[![Report Issue](https://img.shields.io/github/issues/rubyworks/hashery.svg?style=flat)](https://github.com/rubyworks/hashery/issues)

[Homepage](https://rubyworks.github.io/hashery) &middot;
[Development](https://github.com/rubyworks/hashery) &middot;
[Report Issue](https://github.com/rubyworks/hashery/issues)


## Description

Among Ruby Facets most common additions were an assortment
of Hash-like classes. To better support this collection
of libraries it was deemed prudent to create a new project
specifically for them. Hence the *Facets Hashery*.

Included in this collection are the widely used LRUHash,
the auto-sorting Dictionary class, a number of _open_ classes
similar to the standard OpenStruct, some variations of the
standard Hash class and a few other yummy morsels.


## Usage

For instruction on usage, please see the individual library files
included in this collection and read the demo documents which give
examples of almost all features.


### LRUHash

`Hashery::LRUHash` is a size-limited Hash that evicts the least recently
used entry when full. It can be required on its own:

```ruby
require 'hashery/lru_hash'

cache = Hashery::LRUHash.new(2)
cache[:a] = 1
cache[:b] = 2
cache[:a]            # reading :a makes it the most recently used
cache[:c] = 3        # full, so :b, the least recently used, is evicted

cache.keys           # => [:c, :a]  (most recently used first)
cache.fetch(:b, 0)   # => 0
```

Reading with `#[]`, `#fetch`, `#assoc`, `#rassoc`, `#key` or `#values_at`
marks an entry as most recently used; `#has_key?`, `#has_value?` and iteration
do not. Like `Hash.new`, it takes an optional default value or block. Set
`#release_proc` to be told about every entry that leaves the cache:

```ruby
cache.release_proc = ->(key, value) { value.close }
```

An LRUHash is not thread-safe; guard it with a `Mutex` if threads share it.


### Core Extensions

Hashery adds four core extensions of Ruby's Hash class: `#retrieve`,
`#rekey`, `#rekey!` and `Hash.create`. The first is simply an alias
for `#[]`. The later two have proven too useful over the years to
omit. And the last is a convenience class method for populating
a new hash with another hash upon initialization. All of these are
sorely missing for Ruby itself, which is why they are provided here.


## Installation

Hashery requires Ruby 2.7 or newer. To install with RubyGems simply
open a console and type:

    $ gem install hashery

Or add it as a dependency to your project's Gemfile:

    gem "hashery"


## Authors

Developers who have contributed code to the project include:

* Kirk Haines
* Joshua Hull
* Robert Klemme
* Jan Molic
* George Moschovitis
* Jeena Paradies
* Erik Veenstra


## Contributing

Don't be a lump on a log. See an issue? Have a suggestion? Want to help?
Well *git* in there!

### Communicating

The project is hosted on GitHub so the easiest means of communication
is via the [Issues](https://github.com/rubyworks/hashery/issues) page.

### Testing

Hashery uses [QED](https://rubyworks.github.io/qed) and
[Lemon](https://rubyworks.github.io/lemon) test frameworks.
The QED framework to create well tested high-level documentation.
Lemon is used to create low-level unit tests. Install the development
dependencies and run both via:

    $ bundle install
    $ bundle exec rake

Or run the QED specs on their own via:

    $ bundle exec qed -Ilib demo/

And the Lemon unit tests via Rubytest:

    $ bundle exec rubytest -Ilib -Itest test/

### Patches

Hashery's repository is hosted on [GitHub](https://github.com/rubyworks/hashery).
If you'd like to offer up a fix or feature, fork the repo and submit a pull
request (preferably in a topic branch). I assume you have heard
all the talk about proper practices, so I won't bug you with it yet again.


## Copyrights

Copyright (c) 2010 Rubyworks

Licensed under the *BSD-2-Clause* license.

See LICENSE.txt file for further details.

Some libraries included in the Hashery have special copyrights
attributing specific authors. Please see each library script for
specifics and the NOTICE.txt file for an overview.

