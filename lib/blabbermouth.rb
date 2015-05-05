require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string'
require 'blabbermouth/configuration'
require 'blabbermouth/gawkers'
require 'blabbermouth/blabber'

module Blabbermouth
  mattr_reader :configuration
  @@configuration = Blabbermouth::Configuration.new

  def self.configure(&block)
    @@configuration.configure &block
  end

  def self.blabber(*gawkers)
    Blabbermouth::Blabber.new *gawkers
  end

  def self.new(*gawkers)
    blabber *gawkers
  end

  def self.error(key, e, *args)
    opts = args.extract_options!
    gawkers = args.concat([opts.slice!(:data)])
    blabber(*gawkers).error(key, e, opts)
  end

  def self.info(key, msg=nil, *args)
    opts = args.extract_options!
    gawkers = args.concat([opts.slice!(:data)])
    blabber(*gawkers).info(key, msg, opts)
  end

  def self.increment(key, by=1, *args)
    opts = args.extract_options!
    gawkers = args.concat([opts.slice!(:data)])
    blabber(*gawkers).increment(key, by, opts)
  end

  def self.count(key, total, *args)
    opts = args.extract_options!
    gawkers = args.concat([opts.slice!(:data)])
    blabber(*gawkers).count(key, total, opts)
  end

  def self.time(key, duration=nil, *args, &block)
    raise "Blabbermouth.time requires a duration or block" if duration.nil? && !block_given?
    opts = args.extract_options!
    gawkers = args.concat([opts.slice!(:data)])
    blabber(*gawkers).time(key, duration, opts, &block)
  end
end
