QED.configure 'cov' do
  require 'simplecov'
  SimpleCov.command_name 'QED'
  SimpleCov.start do
    add_filter '/demo/'
    coverage_dir 'log/coverage'
  end
end

