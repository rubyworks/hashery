#!/usr/bin/env ruby

Test.run :default do |run|
  $:.unshift 'test'
  $:.unshift 'lib'
end

Test.run :cov do |run|
  #require 'lemon'
  #require 'ae'

  $:.unshift 'test'
  $:.unshift 'lib'

  require 'simplecov'
  SimpleCov.command_name 'RubyTest'
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/lib/hashery/ordered_hash.rb'
    coverage_dir 'log/coverage'
  end

  run.files << 'test/case_*.rb'
end

