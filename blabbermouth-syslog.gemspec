$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/syslog/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-syslog"
  s.version     = Blabbermouth::Syslog::VERSION
  s.summary     = "Syslog bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that posts to Syslog"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-syslog.rb", "lib/blabbermouth/syslog/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/syslog.rb", "spec/blabbermouth/syslog/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
