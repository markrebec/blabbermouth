$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/rails/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-rails"
  s.version     = Blabbermouth::Rails::VERSION
  s.summary     = "Rails bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that writes to the Rails Logger"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-rails.rb", "lib/blabbermouth/rails/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/rails.rb", "spec/blabbermouth/rails/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "rails"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
