# Status

*Updated 2026-11-17*

## Releases

- **2.2.0** released 2026-11-16 (tag `2.2.0`; tags never take a `v`, and
  the Rakefile makes `rake release` follow that, `036dccd`).
- **2.2.1** is ready on `master` (`9e7c7a7`), not yet released: Dictionary
  fixes, including issue #7 (`fdc7cdf`, `0e8e5c4`). HISTORY says
  "2.2.1 / unreleased"; date it when the user releases.

## Constraints

- pdf-reader pins `hashery ~> 2.0` and accounts for nearly all of
  hashery's use, through `Hashery::LRUHash`. Keep LRUHash's API and
  behavior unchanged in 2.x. The user chose this (2026-11-09); breaking
  ideas wait for a 3.0, listed in `TODO.md`.
- The user chose to keep the Rubyworks test tools (Lemon, AE, QED,
  rubytest) rather than port to Minitest.

## Open

- **Drop `rubytest-cli` from the Gemfile once rubytest supports Ruby
  2.7.** rubytest 0.9.0 merged the CLI back in but requires Ruby >= 3.1,
  so hashery's CI (Ruby 2.7 and up) still needs rubytest-cli, and with
  both installed `bundle exec rubytest` warns that two gems ship a
  `rubytest` executable. The user said on 2026-11-17 that a new rubytest
  release will lower its floor to Ruby 2.7. When it's out, depend on that
  version of `rubytest` instead and check that CI passes on 2.7. Mail to
  `@rubyworks` about it: `mail/sent/20261117-135738Z-@rubyworks--rubytest-no-frozen-string-bug-two-small-issues.md`.
