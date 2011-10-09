# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "amos"
  s.version = "0.0.5"

  s.summary = "amos - a model only server."
  s.description = "A simple server that determines the model and action data based upon the incoming url."

  s.files = Dir["lib/**/*"] + 
               ["MIT-LICENSE", "Rakefile", "README.rdoc"] + 
            Dir["app/**/*"] + 
            Dir["config/**/*"]+
            Dir["spec/**/*"]+
               ["test/spec_helper.rb", "test/test_helper.rb"]+
            Dir["test/support/**/*"]+
            Dir["test/dummy/app/**/*"]+
            Dir["test/dummy/config/**/*"]+
            Dir["test/dummy/db/migrate/**/*"]+
            Dir["test/dummy/features/**/*"]

  s.author = 'Geoff Drake'
  s.email = 'drakeg@mandes.com'
  s.homepage = 'http://rubygems.org/gems/amos'

  s.required_ruby_version = '>= 1.8.1'
  s.add_dependency('rails', '~> 3.0')
  s.add_dependency('cancan', '>= 1.6.6')
  s.add_dependency('will_paginate', '~> 3.0.pre2')
  
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('sqlite3-ruby')
  s.add_development_dependency('ruby-debug')
  s.add_development_dependency('launchy')
  s.add_development_dependency('syntax')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('factory_girl_rails')
  s.add_development_dependency('cucumber-rails')
  s.add_development_dependency('pickle')
  
end