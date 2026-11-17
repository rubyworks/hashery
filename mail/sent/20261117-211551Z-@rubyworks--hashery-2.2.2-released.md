Sent: 2026-11-17T21:15:52Z via local
Id: 381ba074

hashery 2.2.2 is on RubyGems as of 2026-11-17 (tag `2.2.2`, commit `2f3ab62`; https://rubygems.org/api/v1/versions/hashery/latest.json returns 2.2.2). It follows 2.2.1, released earlier the same day with Dictionary fixes, including issue #7. Neither release touches LRUHash, so pdf-reader, which pins `hashery ~> 2.0`, isn't affected.

2.2.2 fixes PathHash, which had been broken since 2.0: reading any key raised NameError, because it referred to OrderedHash without loading it and to SlashedHash, its name before 2.0. About a dozen other bugs went with it (`==`, `expand`, `ordered!`, `index`, `size`/`each` seeing no entries, copies sharing entries, `a` matching `ab`). PathHash had no tests; it has 33 now. CI passed on Ruby 2.7 through 4.0 for `2f3ab62`.

On rubytest 0.11.0, since its CI doesn't cover Ruby 4.0: hashery's suite passes with it on 4.0. I ran it in a ruby:4.0-slim container, where `bundle list` showed rubytest 0.11.0, and also on 2.7 the same way. That covers the unit tests, with frozen string literals on as well, plus the QED demos and `rake test`.

Two things about the website that may apply beyond hashery:

1. hashery's site (gh-pages) is rebuilt as one self-contained page, live at https://rubyworks.github.io/hashery. The repo's Website field said http://rubyworks.github.com/hashery, which no longer resolves (`dig rubyworks.github.com` returns nothing). I changed it to the github.io address. 50 of the 74 unarchived repos in the rubyworks organization still have a `*.github.com` Website field. I found them with `gh api orgs/rubyworks/repos`, filtering `homepage` for `.github.com`; they include qed, lemon, ae, rubytest and facets. I changed none of them.

2. GitHub refused to turn on HTTPS enforcement for hashery's site through the API (`PUT repos/rubyworks/hashery/pages` with `https_enforced=true` returned 404, "The certificate does not exist yet", also after a fresh Pages build). The site works over https, but http doesn't redirect to it. The other old project sites probably behave the same way, but I checked only hashery's.
