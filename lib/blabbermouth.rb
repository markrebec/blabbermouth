require 'blabbermouth/gawkers'
require 'blabbermouth/blabber'

module Blabbermouth
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

  def self.increment(key, by, *gawkers, data: {})
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
