$:.push File.expand_path("../lib", __FILE__)
require "blabbermouth/redis/version"

Gem::Specification.new do |s|
  s.name        = "blabbermouth-redis"
  s.version     = Blabbermouth::Redis::VERSION
  s.summary     = "Redis bystander for Blabbermouth"
  s.description = "Bystander for Blabbermouth that writes to Redis"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.files       = Dir["lib/blabbermouth-redis.rb", "lib/blabbermouth/redis/**/*"]
  s.test_files  = Dir["spec/spec_helper.rb", "spec/support/redis.rb", "spec/blabbermouth/redis/**/*"]
  s.homepage    = "http://github.com/markrebec/blabbermouth"

  s.add_dependency "blabbermouth"
  s.add_dependency "redis"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
