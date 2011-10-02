# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "amos"
  s.summary = "amos - a model only server."
  s.description = "A simple server that determines the model and action data based upon the incoming url."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
  s.required_ruby_version = '>= 1.8.1'
  s.add_dependency('rails', '>= 3.0.4')
  s.author = 'Geoff Drake'
  s.email = 'drakeg@mandes.com'
end