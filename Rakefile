# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rake/rdoctask'

require 'rake/testtask'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'


desc 'Run specs and cukes'
task :test => [:spec, :cuke] do
end
 
desc 'Run unit tests'
   
Rake::TestTask.new(:unittest) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Amos'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.verbose = false
  # Put spec opts in a file named .rspec in root
end

desc "Run cucumber features in the test/dummy directory"
task :cuke do
  sh 'cd test/dummy; cucumber features'
end



