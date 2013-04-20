#!/usr/bin/env rake

# To turn specs with verbose output:
#   bundle exec rake test:spec TESTOPTS="--verbose"
#
# For additional help:
#   rake --tasks
#
require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new(:spec) do |t|
  ENV["RACK_ENV"] = "test"
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end

desc "Uninstall the current version of titleize_pt"
task :uninstall do
  puts `gem uninstall -x titleize_pt` # -x flag uninstalls executables too without confirmation
end
