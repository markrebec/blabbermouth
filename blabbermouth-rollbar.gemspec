$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-rollbar"
  s.version     = Blabbermouth::VERSION
  s.summary     = "Rollbar gawker for Blabbermouth"
  s.description = "Gawker for Blabbermouth that posts to Rollbar"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-rollbar.rb", "lib/blabbermouth/version", "lib/blabbermouth/gawkers/rollbar.rb"]
  s.test_files  = Dir["spec/support/rollbar.rb", "spec/blabbermouth/gawkers/rollbar.rb"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "rollbar"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
