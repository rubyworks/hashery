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

### Dictionary

* **Decide what `reverse!` means for a sorted Dictionary.** It does nothing
  now: the sort order is applied again on the next read. It could drop the
  sort order, or reverse it (sort descending) from then on. `reverse`
  already returns an unsorted, reversed copy.

* **`to_h` and `to_hash` copy the default proc as is.** For a Dictionary
  made with a block, such as `Dictionary.auto`, that proc writes into the
  Dictionary, not the returned Hash: `d.to_h[:x]` adds `:x` to `d`.
  `replace` with such a Dictionary takes on the same proc. Either drop the
  default from the copy or rebuild it for the Hash.

### PathHash

* **Keep its entries where Hash can see them, or stop subclassing Hash.**
  PathHash is a Hash but keeps its entries in a table of its own, so the
  Hash methods it doesn't override see an empty Hash: `select` and `any?`
  find nothing, `{}.merge(path_hash)` adds nothing, and `merge` stores the
  new entries where PathHash never looks. 2.2.2 overrides the common
  reads (`each`, `size`, `key?`, `values`, `to_a`, `to_h`) but not these.

### Whole library

* **Base every hash class on one base class with callbacks** (issue #16),
  so the variations (CRUDHash, KeyHash, CastingHash, ...) become
  configurations of it instead of separate implementations.

See also `work/NOTES.rdoc` for the TODO comments collected from the source.
