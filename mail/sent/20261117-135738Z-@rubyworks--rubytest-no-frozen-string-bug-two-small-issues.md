Sent: 2026-11-17T13:57:38Z via local
Id: 15db9a64

The user asked me to tell you about this.

On 2026-11-09, while modernizing hashery, I wrote down that rubytest crashes with frozen string literals turned on:
`RUBYOPT=--enable=frozen-string-literal rubytest -Ilib -Itest test/` printed only `ERROR: can't modify frozen String: ""` and exited 255.
I recorded it as a rubytest bug. It isn't one.

Running the same command with `--debug` (against a checkout of hashery's 2.1.2 tag, Ruby 3.4.9) shows the FrozenError comes from hashery's own `IniHash.read_comment_from_file` (lib/hashery/ini_hash.rb:270 in 2.1.2), raised while a test file was loading. hashery 2.2.0 fixed that. Its 223 unit tests now pass under frozen string literals with both rubytest 0.9.0 and 0.8.1. Nothing to fix in rubytest for this.

Two smaller rubytest things did turn up, in case either is worth an issue:

1. An error raised outside a test, for example while a test file loads, ends the whole run with just `ERROR: <message>`. There's no file, line or backtrace, and no hint that `--debug` shows them. That output comes from `run!` in lib/rubytest/runner.rb (line 22 in 0.9.0: `$stderr.puts('ERROR: ' + error.to_s)`). It's why I blamed rubytest. Printing the first backtrace line, or suggesting `--debug`, would have avoided it.

2. rubytest 0.9.0 merged the CLI back in and ships `bin/rubytest`, but rubytest-cli 0.2.0 ships a `rubytest` executable too. With both installed, `bundle exec rubytest` in hashery warns: "The `rubytest` executable in the `rubytest` gem is being loaded, but it's also present in other gems (rubytest-cli)." Hashery can't simply drop rubytest-cli, because `gem spec rubytest -v 0.9.0 required_ruby_version` is >= 3.1 and hashery's CI goes back to Ruby 2.7, where Bundler picks rubytest 0.8.1, which has no executable. A final rubytest-cli release without its own `bin/rubytest` (depending on rubytest >= 0.9 on Ruby 3.1+) might be one way out; that's your call.
