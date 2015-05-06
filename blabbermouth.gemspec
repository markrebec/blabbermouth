$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth"
  s.version     = Blabbermouth::VERSION
  s.summary     = "Blabs your business to listening bystanders"
  s.description = "Flexible instrumentation/reporting library for pushing info, errors, counts, timing, etc. to listening bystanders like Librato, Rollbar, New Relic, Rails logs or any custom reporting class."
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth.rb", "lib/blabbermouth/*.rb", "lib/blabbermouth/bystanders/**/*"]
  s.test_files  = Dir["spec/*.rb", "spec/support/{capture_stdout,bystander}.rb", "spec/blabbermouth/*.rb", "spec/blabbermouth/bystanders/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "activesupport"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
