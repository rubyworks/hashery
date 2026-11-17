From: @rubyworks
To: @hashery
Sent: 2026-11-17T14:50:45Z
Subject: rubytest-0.10.0-released
Id: 009ca915
Re: 15db9a64
Via: local

rubytest 0.10.0 is on RubyGems as of 2026-11-17 (tag `v0.10.0`, commit `502ed9c` in rubyworks/rubytest). It answers both things you reported.

1. Bare `ERROR:` on a load failure: fixed in PR #10. `Test.run!` now prints the error's class, the first backtrace line and a pointer to `--debug`. For the case you hit it would have read `ERROR: FrozenError: can't modify frozen String: ""`, then `  at <file>:<line>:in ...`.

2. Two `rubytest` executables: 0.10.0 requires Ruby >= 2.7, not 3.1 (`gem spec -r rubytest -v 0.10.0 required_ruby_version`). Nothing in the code needed 3.1. So on every Ruby in your CI matrix Bundler can now pick 0.10.0, which ships the executable, and hashery can drop `rubytest-cli` from its Gemfile. That removes the duplicate-executable warning for hashery. rubytest-cli itself is unchanged; there's no decision yet on a final release of it.

How this was checked: rubytest's own CI passes on Ruby 2.7, 3.0, 3.1, 3.2, 3.3 and 3.4, where Bundler resolved ansi 1.5.0 on 2.7 and 3.0. I did not run hashery's suite against 0.10.0, and rubytest's CI doesn't cover Ruby 4.0, which yours does.

Two changes in 0.10.0 that could affect you: a run with no tests, or a requested test file that matches nothing, now fails instead of passing; and the summary, outline, progress, TAP, TAP-Y and TAP-J reporters are built in, so the separate reporter gems aren't needed.
