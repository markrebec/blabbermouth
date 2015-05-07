# Blabbermouth

[![Build Status](https://travis-ci.org/markrebec/blabbermouth.png)](https://travis-ci.org/markrebec/blabbermouth)
[![Coverage Status](https://coveralls.io/repos/markrebec/blabbermouth/badge.svg?1=1)](https://coveralls.io/r/markrebec/blabbermouth)
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

The simplest way to start using blabbermouth is to just call the provided core methods directly on the `Blabbermouth` module:

    # info - logs an event as info with an optional message and data hash
    Blabbermouth.info('my_app.some_namespace.my_action', 'App did something', data: {some: 'other data'})
    
    # error - logs an exception with an optional data hash
    begin
      # do stuff
    rescue => e
      Blabbermouth.error('my_app.action.failed', e, data: {other: ['arguments', 'can go here']})
    end
    
    # increment - increment a counter (or log a 'tick' depending on the bystander) with an optional integer and data hash
    Blabbermouth.increment('my_app.some_counter', 3) # increment by 3, default is 1
    
    # count - log a total count with an optional data hash
    Blabbermouth.count('my_app.total_things', 250)
    
    # time - logs a timed duration with an optional data hash, can execute and time a block for you
    Blabbermouth.time('my_app.some_job.execution_time', 30, data: {job_args: {whatever: 'stuff'}})
    Blabbermouth.time('my_app.my_block.execution_time') do
      sleep 30
    end

This will use the default configured bystander(s), but you can also override those defaults when calling the method:

    # blabs an error to librato and rollbar, will NOT post to the default bystanders
    Blabbermouth.error('my_app.some_action.failed', e, :rollbar, :librato)
    
    # if you want to post to your default bystander as well, you'll have to specify it
    # this example assumes your default bystander is configured as :stdout
    Blabbermouth.error('my_app.some_action.failed', e, :stdout, :rollbar, :librato)
    
    # or you could reference the configured defaults to be a bit more dynamic
    bystanders = Blabbermouth.configuration.bystanders + [:rollbar, :librato]
    Blabbermouth.error('my_app.some_action.failed', e, *bystanders)

You can also instantiate a `Blabbermouth::Blabber` object, pre-configured with bystanders, then re-use that object without needing to override the defaults for every method call.

    # create a blabber that will blab to the rails log and to librato
    blabber = Blabbermouth::Blabber.new(:rails, :librato) # Blabbermouth.new will also work
    blabber.increment('my_app.my_key') # increment a librato counter by 1 and log the increment value to the rails log

If you happen to be using a custom bystander and you've defined additional methods you'd like to use with blabbermouth, there is some metaprogramming to allow you to do so fairly easily. You cannot use the direct `Blabbermouth.my_method` module methods, but you can instantiate a `Blabbermouth::Blabber` with your bystander and call your method through object. For example, if you've defined a bystander that has a `gauge` method (which is not defined currently as part of the core set of methods), you can still call that method through your blabber object:

    # create a blabber using your custom bystander
    blabber = Blabbermouth::Blabber.new(:my_bystander)
    blabber.gauge('my_app.some_key', my_args) # calls the #gauge method on your bystander

Blabbermouth will check whether a bystander responds to a method before trying to call it, which means you can mix and match bystanders and even if you call a method not supported by one, the rest will still be called.

    # create a blabber using your custom bystander and the rails logger
    blabber = Blabbermouth::Blabber.new(:my_bystander, :rails)
    
    # this will call the #gauge method on your custom bystander but not
    # on the rails bystander, which does not have the method defined
    blabber.gauge('my_app.some_key', my_args)
    
    # if your bystander doesn't have a method defined (let's say error)
    # then it will be skipped when calling that method
    blabber.error('my_app.some_error', e) # will log the error to the rails logger, but not to your bystander

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
