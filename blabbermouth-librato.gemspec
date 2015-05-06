$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/librato/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-librato"
  s.version     = Blabbermouth::Librato::VERSION
  s.summary     = "Librato bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that posts to Librato"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-librato.rb", "lib/blabbermouth/librato/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/librato.rb", "spec/blabbermouth/librato/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "librato-metrics"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
