require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string'
require 'blabbermouth/version'
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
    Blabbermouth::Blabber.error key, e, *args
  end

  def self.info(key, msg=nil, *args)
    Blabbermouth::Blabber.info key, msg, *args
  end

  def self.increment(key, by=1, *args)
    Blabbermouth::Blabber.increment key, by, *args
  end

  def self.count(key, total, *args)
    Blabbermouth::Blabber.count key, total, *args
  end

  def self.time(key, duration=nil, *args, &block)
    Blabbermouth::Blabber.time key, duration, *args, &block
  end
end
