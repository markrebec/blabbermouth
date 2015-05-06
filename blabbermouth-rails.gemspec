$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth-rails/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-rails"
  s.version     = Blabbermouth::RAILS_VERSION
  s.summary     = "Rails bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that writes to the Rails Logger"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-rails.rb", "lib/blabbermouth-rails/**/*", "lib/blabbermouth/bystanders/rails.rb"]
  s.test_files  = Dir["spec/support/rails.rb", "spec/blabbermouth/bystanders/rails.rb"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "rails"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
