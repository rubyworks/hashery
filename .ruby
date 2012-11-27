---
source:
- METADATA
authors:
- name: Trans
  email: transfire@gmail.com
- name: Kirk Haines
- name: Robert Klemme
- name: Jan Molic
- name: George Moschovitis
- name: Jeena Paradies
- name: Erik Veenstra
copyrights:
- holder: Rubyworks
  year: '2010'
  license: BSD-2-Clause
requirements:
- name: detroit
  groups:
  - build
  development: true
- name: qed
  groups:
  - test
  development: true
- name: lemon
  groups:
  - test
  development: true
dependencies: []
alternatives: []
conflicts: []
repositories:
- uri: git://github.com/rubyworks/hashery.git
  scm: git
  name: upstream
resources:
- uri: http://rubyworks.github.com/hashery
  label: Website
  type: home
- uri: http://github.com/rubyworks/hashery
  label: Source Code
  type: code
- uri: http://groups.google.com/group/rubyworks-mailinglist
  label: Mailing List
  type: mail
- uri: http://rubydoc.info/github/rubyworks/hashery/master/frames
  label: Documentation
  type: docs
- uri: http://wiki.github.com/rubyworks/hashery
  label: User Guide
  type: wiki
- uri: http://rubygems.org/gems/hashery
  type: gems
categories: []
extra: {}
load_path:
- lib
- alt
revision: 0
name: hashery
title: Hashery
created: '2010-04-21'
summary: Facets-bread collection of Hash-like classes.
description: ! 'The Hashery is a tight collection of Hash-like classes. Included among
  its many

  offerings are the auto-sorting Dictionary class, the efficient LRUHash, the

  flexible OpenHash and the convenient KeyHash. Nearly every class is a subclass

  of the CRUDHash which defines a CRUD model on top of Ruby''s standard Hash

  making it a snap to subclass and augment to fit any specific use case.'
version: 2.1.0
date: '2012-11-24'
