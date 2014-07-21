#!/usr/bin/env ruby

#ignore 'web', 'log', 'doc', 'tmp', 'work'

desc 'run tests'
task 'test' do
  sh 'rubytest test/'
end

desc 'run demos'
task 'demo' do
  sh 'qed demo/'
end

desc 'coverage report'
task 'coverage' do
  system({'p'=>'coverage'}, 'qed demo/')
  system({'p'=>'coverage'}, 'rubytest test/')
end

