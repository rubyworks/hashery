--- !ruby/object:Gem::Specification 
name: hashery
version: !ruby/object:Gem::Version 
  prerelease: 
  version: 1.5.0
platform: ruby
authors: 
- Thomas Sawyer <transfire@gmail.com>
- Kirk Haines
- Robert Klemme
- Jan Molic
- George Moschovitis
- Jeena Paradies
- Erik Veenstra
autorequire: 
bindir: bin
cert_chain: []

date: 2011-07-06 00:00:00 Z
dependencies: 
- !ruby/object:Gem::Dependency 
  name: syckle
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: qed
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id002
- !ruby/object:Gem::Dependency 
  name: lemon
  prerelease: false
  requirement: &id003 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
  type: :development
  version_requirements: *id003
description: The Hashery is a collection of Hash-like classes, spun-off from the original Ruby Facets library. Included are the widely used OrderedHash, the related but more featured Dictionary class, a number of open classes, similiar to the standard OpenStruct and a few variations on the standard Hash.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .yardopts
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
- test/case_basicstruct.rb
- test/case_dictionary.rb
- test/case_opencascade.rb
- test/case_openhash.rb
- test/case_sparsearray.rb
- test/case_stash.rb
- HISTORY.rdoc
- README.rdoc
- COPYING.rdoc
homepage: http://rubyworks.github.com/hashery
licenses: 
- BSD-2-Clause
post_install_message: 
rdoc_options: 
- --title
- Hashery API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
requirements: []

rubyforge_project: hashery
rubygems_version: 1.8.2
signing_key: 
specification_version: 3
summary: Facets-bread collection of Hash-like classes.
test_files: []

