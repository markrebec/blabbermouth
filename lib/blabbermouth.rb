require 'active_support/core_ext/module/attribute_accessors'
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

  def self.error(key, e, *gawkers, data: {})
    blabber(*gawkers).error(key, e, data: {})
  end

  def self.info(key, msg=nil, *gawkers, data: {})
    blabber(*gawkers).info(key, msg, data: {})
  end

  def self.increment(key, by=1, *gawkers, data: {})
    blabber(*gawkers).increment(key, by, data: {})
  end

  def self.count(key, total, *gawkers, data: {})
    blabber(*gawkers).count(key, total, data: {})
  end

  def self.time(key, duration=nil, *gawkers, data: {}, &block)
    raise "Blabbermouth.time requires a duration or block" if duration.nil? && !block_given?
    blabber(*gawkers).time(key, duration, data: {}, &block)
  end
end
