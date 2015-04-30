$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth"
  s.version     = Blabbermouth::VERSION
  s.summary     = "Blabs your business to various datastores"
  s.description = "Flexible instrumentation/reporting library for pushing info, errors, counts, timing, etc. to various datastores like Librato, Rollbar, Rails logs or custom ActiveRecord models"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/**/*"]
  s.test_files  = Dir["spec/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "faker"
end
