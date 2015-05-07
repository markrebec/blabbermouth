# Blabbermouth

[![Build Status](https://travis-ci.org/markrebec/blabbermouth.png)](https://travis-ci.org/markrebec/blabbermouth)
[![Coverage Status](https://coveralls.io/repos/markrebec/blabbermouth/badge.svg)](https://coveralls.io/r/markrebec/blabbermouth)
[![Code Climate](https://codeclimate.com/github/markrebec/blabbermouth.png)](https://codeclimate.com/github/markrebec/blabbermouth)
[![Gem Version](https://badge.fury.io/rb/blabbermouth.png)](http://badge.fury.io/rb/blabbermouth)
[![Dependency Status](https://gemnasium.com/markrebec/blabbermouth.png)](https://gemnasium.com/markrebec/blabbermouth)

An interface that blabs your business (errors, logging, instrumentation, etc.) to listening bystanders. There are a number of core bystanders provided, either built-in or through additional gems, for things like stdout, rails logger, rollbar, librato, etc.

When using blabbermouth you can configure which bystanders are listening in to the events and messages being reported, which allows you to easily log/track/instrument your application across multiple services. For example, the `librato` and `rollbar` bystanders can be powerful when used alongside one another, in order to do things like graph success vs. error rates in Librato **and** report the full corresponding exceptions and backtraces to Rollbar.

Blabbermouth can also provide redundancy by reporting to multiple services and is a great way to test out new providers (think Librato vs. New Relic), or to A/B test things like messaging queues when evaluating new gems or third party services.

## Getting Started

Add the blabbermouth gem to your Gemfile:

    gem 'blabbermouth'

Then run `bundle install`.

You can also install additional bystanders by adding the appropriate gem(s) to your Gemfile. For example, if you wanted to use the rails logger and rollbar:

    gem 'blabbermouth'
    gem 'blabbermouth-rails'
    gem 'blabbermouth-rollbar'

By default blabbermouth is configured with the `stdout` bystander, which will log all messages to standard output. If you use the `blabbermouth-rails` gem, this is overridden and defaults to the rails logger. This means that when you call something like `Blabbermouth.error` without telling it which bystanders you'd like listening, the defaults will be used.

If you want to set a different default bystander or add other bystanders to the defaults, you can configure blabbermouth to do so (usually in `/config/initializers/blabbermouth.rb`):

    Blabbermouth.configure do |config|
      # Replace the default bystander with Rollbar and Librato
      config.bystanders = [:rollbar, :librato]
      
      # Or add Rollbar to the existing default bystanders (either :stdout or
      # :rails depending on what gems you're using)
      config.bystanders << :rollbar
    end

## Usage

**TODO document usage, provide examples**

## Available Bystanders

There are a number of core bystanders you can use to get started. The `stdout` bystander is built into blabbermouth, and a few other useful ones are provided by core extension gems.

### Stdout

The `stdout` bystander is built-in and provided with the core `blabbermouth` gem. It will format any messages sent to it and log them to standard output. In the future I'd like to provide a way to override the formatting of the logged messages (more easily than monkeypatching the `Stdout#log_message` method or extending to your own custom bystander and overriding that method).

### Rails

The `rails` bystander is provided by the `blabbermouth-rails` gem and is similar to the `stdout` bystander, except it logs messages using the default configured `Rails.logger`.

### Rollbar

The `rollbar` bystander is provided by the `blabbermouth-rollbar` gem. It logs your messages to [Rollbar](http://rollbar.com), which can be useful for logging errors and other info because it can be configured to pass along lots of additional data about requests, sessions, etc.

### Librato

The `librato` bystander is provided by the `blabbermouth-librato` gem, and will ping [Librato](http://librato.com). Librato provides excellent tools to instrument various actions in your application, and it's a great way to track things like background jobs, execution time/performance in production environments, etc. 

### New Relic

Not Yet Implemented

## Custom Bystanders

**TODO document creating your own custom bystanders**

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
