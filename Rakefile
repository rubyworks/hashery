require 'bundler/gem_tasks'

desc 'run unit tests'
task 'test' do
  sh 'rubytest -Ilib -Itest test/'
end

desc 'run demos'
task 'demo' do
  sh 'qed -Ilib demo/'
end

desc 'coverage report'
task 'coverage' do
  system({'p'=>'coverage'}, 'qed -Ilib demo/')
  system({'p'=>'coverage'}, 'rubytest -Ilib -Itest test/')
end

task 'default' => ['test', 'demo']
