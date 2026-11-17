# Status

*Updated 2026-11-17*

## Releases

- **2.2.0** released 2026-11-16 (tag `2.2.0`; tags never take a `v`, and
  the Rakefile makes `rake release` follow that, `036dccd`).
- **2.2.1** is ready on `master`, not yet released: Dictionary fixes,
  including issue #7 (`fdc7cdf`, `0e8e5c4`). HISTORY dated 2026-11-17
  (`deac652`); change the date if the release happens on another day.

## Constraints

- pdf-reader pins `hashery ~> 2.0` and accounts for nearly all of
  hashery's use, through `Hashery::LRUHash`. Keep LRUHash's API and
  behavior unchanged in 2.x. The user chose this (2026-11-09); breaking
  ideas wait for a 3.0, listed in `TODO.md`.
- The user chose to keep the Rubyworks test tools (Lemon, AE, QED,
  rubytest) rather than port to Minitest.

## Open

- **Drop `rubytest-cli` from the Gemfile: rubytest 0.10.0 makes it
  possible.** rubytest 0.9.0 required Ruby >= 3.1, so hashery's CI (Ruby
  2.7 and up) needed rubytest-cli as well, and with both installed
  `bundle exec rubytest` warned that two gems ship a `rubytest`
  executable. rubytest 0.10.0 (released 2026-11-17) requires Ruby >= 2.7
  and ships the executable, per `@rubyworks`
  (`mail/received/20261117-145045Z-@rubyworks--rubytest-0.10.0-released-009ca915.md`).
  Checked 2026-11-17 in a scratch copy with `gem "rubytest", ">= 0.10"` in
  place of `gem "rubytest-cli"`: on Ruby 2.7 and 4.0 all 259 unit tests
  and 10 demos pass, also with frozen string literals. The Gemfile change
  itself is not made yet; it waits for the user. 0.10.0 also fails a run
  that finds no tests, and builds in the reporters.
  Mail that asked for it: `mail/sent/20261117-135738Z-@rubyworks--rubytest-no-frozen-string-bug-two-small-issues.md`.
