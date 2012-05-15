config 'rubytest' do
  $:.unshift 'test'
  $:.unshift 'lib'
end

profile 'coverage' do
  config 'rubytest' do
    $:.unshift 'test'
    $:.unshift 'lib'

    require 'simplecov'
    SimpleCov.command_name 'RubyTest'
    SimpleCov.start do
      add_filter '/test/'
      add_filter '/lib/hashery/ordered_hash.rb'
      coverage_dir 'log/coverage'
    end
  end

  config 'qed' do
    require 'simplecov'
    SimpleCov.command_name 'QED'
    SimpleCov.start do
      add_filter '/demo/'
      coverage_dir 'log/coverage'
    end
  end
end
