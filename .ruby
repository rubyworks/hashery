--- 
name: hashery
company: RubyWorks
title: Hashery
contact: Trans <transfire@gmail.com>
maintainers: 
- Trans <transfire@gmail.com>
pom_verison: 1.0.0
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
resources: 
  repo: git://github.com/rubyworks/hashery.git
  code: http://github.com/rubyworks/hashery
  api: http://rubyworks.github.com/hashery/docs/api
  mail: http://groups.google.com/group/rubyworks-mailinglist
  host: http://rubygems.org/gems/hashery
  wiki: http://wiki.github.com/rubyworks/hashery
  home: http://rubyworks.github.com/hashery
manifest: 
- .ruby
- lib/hashery/association.rb
- lib/hashery/basic_struct.rb
- lib/hashery/basicobject.rb
- lib/hashery/basicstruct.rb
- lib/hashery/casting_hash.rb
- lib/hashery/castinghash.rb
- lib/hashery/dictionary.rb
- lib/hashery/fuzzy_hash.rb
- lib/hashery/fuzzyhash.rb
- lib/hashery/ini.rb
- lib/hashery/linked_list.rb
- lib/hashery/linkedlist.rb
- lib/hashery/lru_hash.rb
- lib/hashery/lruhash.rb
- lib/hashery/memoizer.rb
- lib/hashery/open_cascade.rb
- lib/hashery/open_hash.rb
- lib/hashery/open_object.rb
- lib/hashery/opencascade.rb
- lib/hashery/openhash.rb
- lib/hashery/openobject.rb
- lib/hashery/ordered_hash.rb
- lib/hashery/orderedhash.rb
- lib/hashery/ostructable.rb
- lib/hashery/property_hash.rb
- lib/hashery/propertyhash.rb
- lib/hashery/query_hash.rb
- lib/hashery/queryhash.rb
- lib/hashery/sparse_array.rb
- lib/hashery/sparsearray.rb
- lib/hashery/stash.rb
- lib/hashery/static_hash.rb
- lib/hashery/statichash.rb
- lib/hashery.rb
- lib/hashery.yml
- qed/01_openhash.rdoc
- qed/02_queryhash.rdoc
- qed/03_castinghash.rdoc
- qed/04_statichash.rdoc
- qed/05_association.rdoc
- qed/06_opencascade.rdoc
- qed/07_fuzzyhash.rdoc
- qed/08_properyhash.rdoc
- qed/09_ostructable.rdoc
- qed/applique/ae.rb
- test/case_association.rb
- test/case_dictionary.rb
- test/case_opencascade.rb
- test/case_openhash.rb
- test/case_openobject.rb
- test/case_sparsearray.rb
- test/case_stash.rb
- HISTORY.rdoc
- LICENSE
- README.rdoc
- NOTICE
version: 1.4.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2010 Thomas Sawyer
description: The Hashery is a collection of Hash-like classes, spun-off from the original Ruby Facets library. Included are the widely used OrderedHash, the related but more featured Dictionary class, a number of open classes, similiar to the standard OpenStruct and a few variations on the standard Hash.
summary: Facets-bread collection of Hash-like classes.
authors: 
- Thomas Sawyer
- Kirk Haines
- Robert Klemme
- Jan Molic
- George Moschovitis
- Jeena Paradies
- Erik Veenstra
created: 2010-04-21
