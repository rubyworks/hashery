require 'rake/clean'
CLOBBER.include 'pkg'

require 'bundler/gem_helper'

# Bundler tags releases as v1.2.3, but Hashery's tags have always been
# plain version numbers (1.1.0 ... 2.2.0), so keep it that way.
class Bundler::GemHelper
  def version_tag
    version.to_s
  end
end

Bundler::GemHelper.install_tasks

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
