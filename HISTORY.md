# RELEASE HISTORY

## 2.2.2 / unreleased

This release fixes PathHash, which had been broken for years: reading any
key raised NameError. PathHash also has tests of its own now. LRUHash is
unchanged.

Changes:

* Fix PathHash. `[]`, `==`, `expand`, `ordered!` and `index` raised
  errors; `size`, `each`, `key?`, `values` and `to_a` saw no entries;
  copies shared entries with the original; a key also matched longer keys
  that started with it (`a` matched `ab`); `fetch` ignored its block; and
  `delete` returned an empty PathHash instead of nil for a missing key.

## 2.2.1 / 2026-11-17

This release fixes a number of bugs in Dictionary. Most notably, a
Dictionary kept in order with `order_by_key` or `order_by_value` could no
longer be read at all (not even inspected) once it held a key or value
that didn't compare with the others, such as `nil` (#7). Now sorting by
such an order raises and leaves the Dictionary as it was, and adding an
entry the order can't place raises without storing it. LRUHash is
unchanged.

Changes:

* Fix Dictionary sort orders that can't sort the entries (#7).
* Fix Dictionary#dup and #clone, which shared state with the original
  (clone), or dropped the sort order and default (dup).
* Fix Dictionary#reject!, which returned a filtered copy instead of
  removing entries.
* Fix Dictionary#shift on an empty Dictionary, and #shift and #pop with
  a `nil` key.
* Fix Dictionary[hash] and #replace, which shared the given hash or
  order instead of copying it.
* Fix Dictionary#insert with an existing key or an index past the end.
* Fix Dictionary#[]= with an index and a `nil` or `false` value.
* Fix Dictionary#delete removing 1.0 from the order along with 1.
* Fix Dictionary#== for a sorted Dictionary changed since it was read.

## 2.2.0 / 2026-11-16

This release concentrates on LRUHash, by far the most used part of the
Hashery. Its public API is unchanged, but it has been reimplemented on top
of Ruby's ordered Hash instead of a linked list of nodes, which makes it
about twice as fast, and a number of bugs have been fixed. It also
modernizes the project: Ruby 2.7 or newer is now required, the gem is
built from a plain gemspec, and CI runs on GitHub Actions.

Changes:

* LRUHash is about 2x faster, using Ruby's ordered Hash internally.
* Fix LRUHash#dup and #clone, which shared state with the original.
* Fix LRUHash#inspect and #to_s, which showed keys and values with #to_s
  and failed under frozen string literals.
* LRUHash#keys and #values now list most recently used first, like #each.
* LRUHash#fetch accepts a default argument and its KeyError names the key.
* LRUHash#delete accepts a block for missing keys, like Hash#delete.
* LRUHash#delete_if returns an Enumerator when called without a block.
* Add LRUHash#length.
* Fix IniHash.new with a Hash, and so IniHash.text and .write_to_file.
* Fix IniHash.write_to_file with a comment (used String#each).
* Fix `require 'hashery/static_hash'` on its own.
* Prepare for frozen string literals and fix warnings under `ruby -w`.
* Require Ruby 2.7 or newer.
* Replace Indexer metadata (.index, Index.yml) with hashery.gemspec.
* Replace Travis CI with GitHub Actions.

## 2.1.2 / 2016-05-02

Minor release fixes a test for KeyHash. And that's it.

Changes:

* Fix initialize test for KeyHash class.


## 2.1.1 / 2013-08-21

This minor release clarifies the licensing. The entire library is now
distributed under the BSD-2-Clause license, also known as the FreeBSD
license. In addition this release provides a bug fix for flattening
arrays that contain an OpenCascade object.

Changes:

* Clarify licensing.
* Fix #flatten on Arrays that contain an OpenCascade.


## 2.1.0 / 2012-11-24 (Golden Retriever)

The major change of the 2.1 release is to switch over to `Hash#fetch`
as the fundamental CRUD read method in-place of the previous `#read` core
extension (an alias of `#[]`). This is a pretty fundamental change which
required modification of a number of classes. So please do extra-diligence
and file an issue if you experience any problems.

In addition, the Hash#read core extension has been renamed to Hash#retrieve
to avoid any possible confusion with IO objects. This release also fixes
a couple of issues with 1.8 compatibility and makes a few other small 
enhancements.

Changes:

* Rename Hash#read to Hash#retrieve.
* Deprecate `Dictionary.alpha` in favor of `Dictionary.alphabetic`.
* Add support for block argument in Dictionary#order_by_key and #order_by_value.
* Fix OpenHash issues with Ruby 1.8.x compatibility.
* OpenHash methods are opened up via `protected` instead of `private`.
* Change OpenCascade to auto-create the subclass when inherited.


## 2.0.1 / 2012-07-06

This minor release fixes an issue with OpenCascade (#13).
The key_proc procedure wasn't being passed along to sub-cascades. 

Changes:

* OpenCascade passes along key_proc to children.


## 2.0.0 / 2012-05-11 (Crud Space)

This is a big release for Hashery which both culls some of it's
less fitting classes and modules while greatly improving the rest.
The first and most immediate change is use of a proper namespace.
All classes and modules are now appropriately kept in the `Hashery`
namespace. To get the old behavior you can `include Hashery` as the
toplevel. For the other changes and improvements dive into the 
API documentation.

Changes:

* Use proper Hashery namespace.
* Add CRUDHash, which also serves a good base class.
* Improved OpenHash to be nearly 100% open.
* Deprecate BasicStruct, as it would be better to improve OpenStruct.
* Deprecate BasicCascade, though it never really came to be.
* Deprecate BasicObject emulator, as it is no longer needed.
* Deprecate Memoizer, not sure how that got in here anyway.
* Deprecate Ostructable, which can be paired up with better OpenStruct.
* Removed open_object.rb, which has long been deprecated.


## 1.5.1 / 2012-05-09

This release adds transformative #each method to OpenCascade, to
ensure #each returns an OpenCascade. Also, BasicCascade has been
added that is like OpenCascade by fully open by use of BasicObject
as a base class.

Changes:

* Fix OpenCascade#each (porecreat).
* Introduce BasicCascade class.
* Renamed `Ini` class to `IniHash` class.


## 1.5.0 / 2011-11-10 (Devil's Core)

In this release, CoreExt module has been added to encapsulate
methods that extend Ruby's core Hash class (there are only a few).
Presently these are only loaded when using `require 'hashery'`.
If you are cherry-picking from Hashery but still want the core
extensions, you need to use `require 'hasery/core_ext'` first.
In addition, BasicStruct class now has a #key method. And finally
this release switches licensing to BSD 2-Clause.

Changes:

* Use CoreExt mixin for core Hash extensions.
* Add BasicStruct#key method (b/c #index is deprecated in Ruby 1.9).
* Deprecate SparseArray class.
* Switch license to BSD-2-Clause license.


## 1.4.0 / 2011-01-19 (Back To Basics)

This release includes a copy of Ruby Facets' BasicObject class, which
fixes the loading bug of the previous version. This release also renames
OpenObject to BasicStruct, which is a much better description of what the
class actually provides.

Changes:

* Rename OpenObject to BasicStruct.
* Fix basicobject.rb loading issue.


## 1.3.0 / 2010-10-01 (Private Property)

This release fixes a minor bug in CastingHash and adds a new
PropertyHash class.

Changes:

* 1 New Library

  * Added PropertyHash

* 1 Bug Fix

  * Fixed CastingHash#new where #to_proc is called against NilClass


## 1.2.0 / 2010-06-04 (Fuzzy Wuzzy)

This release makes two significant changes to the Hashery.
First, we have a new shiny library called FuzzyHash by
Joshua Hull. It's a cool idea that allows hash keys to be
regular expressions. Secondly, OpenCascade is now a subclass
of OpenHash rather than OpenObject (to go along with the
changes of the last release), and it now support cascading
within Arrays.

Changes:

* 1 New Library

  * FuzzyHash by Joshua Hull

* 1 Major Enhancement

  * OpenCascade subclasses OpenHash and handles Array cascading.


## 1.1.0 / 2010-04-28 (Ugly Ducklings)

A follow-up release of Hashery that adds two new libraries:
Association and SparseArray. Both of these may seem like odd
entries, but they each belong in a unique way. An Association
is akin to a single entry Hash --it represents a pairing.
While a SpareArray, though compatible with the Array class,
is completely under-pinned by a Hash in order to make it
efficient when no entries are given for a set of indexes,
hence "sparse".

Changes:

* 2 New Libraries

  * Added association.rb
  * Added sparsearray.rb


## 1.0.0 / 2010-04-21 (Hatching Hashery)

This is the first release of the Facets Hashery.
Most of included classes come directly from Ruby
Facets, so they have been around a while and are
in good working condition.

Some improvements are planned for the next release.
In particular the OrderHash and Dictionary, which
presently have essentially the same coding, will
diverge to target slightly different use cases.

Changes:

* Happy Birthday!

