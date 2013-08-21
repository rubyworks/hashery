#!/usr/bin/env ruby

#require 'lemon'
#require 'ae'

Test.configure do |run|
  run.load_path 'lib', 'test'
end

Test.configure 'coverage' do |run|
  # run all tests to get complete coverage report
  run.test_files << 'test/case_*.rb'
  run.load_path 'lib', 'test'
  run.before do
    require 'simplecov'
    SimpleCov.command_name 'RubyTest'
    SimpleCov.start do
      add_filter '/test/'
      add_filter '/lib/hashery/ordered_hash.rb'
      coverage_dir 'log/coverage'
    end
  end
end

