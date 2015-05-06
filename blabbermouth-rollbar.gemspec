$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/rollbar/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-rollbar"
  s.version     = Blabbermouth::Rollbar::VERSION
  s.summary     = "Rollbar bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that posts to Rollbar"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-rollbar.rb", "lib/blabbermouth/rollbar/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/rollbar.rb", "spec/blabbermouth/rollbar/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "rollbar"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
