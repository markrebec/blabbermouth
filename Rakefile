require 'rspec/core/rake_task'

desc 'Run the specs'
RSpec::Core::RakeTask.new do |r|
  r.verbose = false
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -r rubygems -r rails -I lib -r blabbermouth"
end

task :build do
  puts `gem build blabbermouth.gemspec`
  puts `gem build blabbermouth-syslog.gemspec`
  puts `gem build blabbermouth-rails.gemspec`
  puts `gem build blabbermouth-rollbar.gemspec`
  puts `gem build blabbermouth-librato.gemspec`
  puts `gem build blabbermouth-new_relic.gemspec`
end

task :push do
  require 'blabbermouth/version'
  puts `gem push blabbermouth-#{Blabbermouth::VERSION}.gem`
  puts `gem push blabbermouth-syslog-#{Blabbermouth::VERSION}.gem`
  puts `gem push blabbermouth-rails-#{Blabbermouth::VERSION}.gem`
  puts `gem push blabbermouth-rollbar-#{Blabbermouth::VERSION}.gem`
  puts `gem push blabbermouth-librato-#{Blabbermouth::VERSION}.gem`
  puts `gem push blabbermouth-new_relic-#{Blabbermouth::VERSION}.gem`
end

task release: [:build, :push] do
  puts `rm -f blabbermouth*.gem`
end

task :default => :spec
