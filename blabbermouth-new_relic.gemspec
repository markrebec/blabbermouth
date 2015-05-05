$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-new_relic"
  s.version     = Blabbermouth::VERSION
  s.summary     = "New Relic gawker for Blabbermouth"
  s.description = "Gawker for Blabbermouth that posts to New Relic"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-new_relic.rb", "lib/blabbermouth/version", "lib/blabbermouth/gawkers/new_relic.rb"]
  s.test_files  = Dir["spec/support/new_relic.rb", "spec/blabbermouth/gawkers/new_relic.rb"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "newrelic_rpm"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
