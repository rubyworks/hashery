# TODO

## Ideas for 3.0

These change behavior, so they were kept out of 2.x. pdf-reader, which
accounts for nearly all of Hashery's use, pins `hashery ~> 2.0` and depends
on LRUHash behaving exactly as it does now. A 3.0 would not reach those users
unless pdf-reader chose to upgrade.

### LRUHash

* **`has_value?` / `value?` should compare with `==`, like Hash.** They use
  `eql?` now, so `lru.has_value?(1.0)` is false when a value is `1`, while
  `{a: 1}.has_value?(1.0)` is true. `rassoc` does the same and should change
  with them.

* **Add `LRUHash#==`.** Two LRUHashes with the same contents are not `==`
  now (it is identity). Decide whether recency order and `max_size` count,
  and whether an LRUHash can equal a plain Hash.

* **Add `LRUHash#to_hash`.** Without it an LRUHash can't be used where Ruby
  converts to a Hash implicitly (`**lru`, `Hash#merge(lru)`, `Hash(lru)`);
  each raises TypeError now. Adding it changes existing code, though: on
  Ruby 2.7 an LRUHash passed as the last argument to a method that takes
  keywords becomes the keywords, and on every Ruby `hash == lru` starts
  calling `lru == hash` instead of returning false.

* **Make `freeze` meaningful.** Freezing an LRUHash doesn't stop
  `lru[:b] = 2` now, because the internal table isn't frozen. But even a
  read reorders entries, so a truly frozen LRUHash must either raise on
  every read or stop tracking recency once frozen. Pick one.

### Whole library

* **Base every hash class on one base class with callbacks** (issue #16),
  so the variations (CRUDHash, KeyHash, CastingHash, ...) become
  configurations of it instead of separate implementations.

## Elsewhere

* **Rubytest crashes with frozen string literals turned on**
  (`RUBYOPT=--enable=frozen-string-literal`). That's a bug in the rubytest
  gem, not Hashery, but it's why CI only runs the QED demos in that mode,
  not the unit tests. Once it's fixed, add the unit tests to that CI step.

See also `work/NOTES.rdoc` for the TODO comments collected from the source.
