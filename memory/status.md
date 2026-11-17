# Status

*Updated 2026-11-17*

## Releases

- **2.2.0** released 2026-11-16 (tag `2.2.0`; tags never take a `v`, and
  the Rakefile makes `rake release` follow that, `036dccd`).
- **2.2.1** released 2026-11-17 (tag `2.2.1`, `deac652`): Dictionary
  fixes, including issue #7 (`fdc7cdf`, `0e8e5c4`). LRUHash unchanged.
- **2.2.2** not released: the PathHash fix (`4e2d468`, committed
  2026-11-17 but not pushed; the user pushes it). HISTORY says
  "2.2.2 / unreleased" and `version.rb` still says 2.2.1: bump and date
  both when releasing. PathHash had been broken since 2.0 (reading any
  key raised NameError); what it still lacks is in `TODO.md`.

## Constraints

- pdf-reader pins `hashery ~> 2.0` and accounts for nearly all of
  hashery's use, through `Hashery::LRUHash`. Keep LRUHash's API and
  behavior unchanged in 2.x. The user chose this (2026-11-09); breaking
  ideas wait for a 3.0, listed in `TODO.md`.
- The user chose to keep the Rubyworks test tools (Lemon, AE, QED,
  rubytest) rather than port to Minitest.

## Open

- **HTTPS enforcement for the site.** GitHub's API refuses it ("The
  certificate does not exist yet", 2026-11-17), so http still serves the
  page without redirecting. Left for the user to try under Settings >
  Pages.

## Done

- **Website rebuilt** (2026-11-17, `gh-pages` `29bd8f3`): one
  self-contained page drawn from the README, keeping the
  "Hashery {egg}" logo, which the user wanted kept. `qed.html` redirects
  to `demo/` on GitHub. The repo's Website field now points to
  https://rubyworks.github.io/hashery (it was a dead github.com address).

- **Dropped `rubytest-cli` for `rubytest >= 0.10`** in the Gemfile
  (`eb335d0`, 2026-11-17); CI passed on Ruby 2.7 through 4.0, with no
  duplicate-executable warning in the logs. rubytest 0.10.0 lowered its
  floor to Ruby 2.7 after hashery's mail
  (`mail/sent/20261117-135738Z-@rubyworks--rubytest-no-frozen-string-bug-two-small-issues.md`;
  reply `mail/received/20261117-145045Z-@rubyworks--rubytest-0.10.0-released-009ca915.md`).
  Note that rubytest 0.10 fails a run that finds no tests.
- **rubytest 0.11.0** (released 2026-11-17) needs no change: checked
  2026-11-17 in a scratch copy of `eb335d0`, where on Ruby 2.7 and 4.0
  the 259 unit tests (also with frozen string literals), the 10 demos and
  `rake test` all pass. It folds in every companion gem (rubytest-tap,
  -summary, -progress, -outline, -suite, -rake, -html), now archived, and
  some will be yanked from RubyGems: never depend on them. It adds
  `Test::Rake::TestTask` (`require 'rubytest/rake'`), which doesn't read
  `etc/test.rb`, so the coverage task would still shell out; not adopted.
  Per `mail/received/20261117-191327Z-@rubyworks--rubytest-0.11.0-released-733efef2.md`.
