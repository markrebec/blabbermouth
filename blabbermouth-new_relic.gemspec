$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/new_relic/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-new_relic"
  s.version     = Blabbermouth::NewRelic::VERSION
  s.summary     = "New Relic bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that posts to New Relic"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-new_relic.rb", "lib/blabbermouth/new_relic/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/new_relic.rb", "spec/blabbermouth/new_relic/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "newrelic_rpm"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
