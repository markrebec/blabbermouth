$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth"
  s.version     = Blabbermouth::VERSION
  s.summary     = "Structured and custom logging for rails"
  s.description = "Structure logging and custom formatters for rails."
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth.rb", "lib/blabbermouth/*.rb"]
  s.test_files  = Dir["spec/*.rb"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "rails", ">= 6.0.0"
  # s.add_dependency "activesupport"
  # s.add_dependency "canfig", ">= 0.0.6"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
