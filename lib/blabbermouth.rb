# simple proxies
require 'blabbermouth/proxy'
require 'blabbermouth/devices'
require 'blabbermouth/contextual'
require 'blabbermouth/leveled'
require 'blabbermouth/event'
require 'blabbermouth/metric'

# structured formatters
require 'blabbermouth/formatter'
require 'blabbermouth/formatters'

# structured logger
require 'blabbermouth/logger'

# rails integration
require 'blabbermouth/railtie' if defined?(Rails)

::Logger::Severity::VERBOSE = -1

module Blabbermouth
  extend Contextual
  Color = Formatters::Color::Config

  def self.logger=(log)
    @logger = log
  end

  def self.logger
    @logger || Rails.logger
  end

  def self.text(*io, context: {})
    new(*io, context: context)
  end

  def self.json(*io, context: {})
    new(*io, context: context, formatter: Formatters::JSON.new)
  end

  def self.color(*io, context: {})
    new(*io, context: context, formatter: Formatters::Color.new)
  end

  def self.new(*io, context: {}, formatter: nil, events: nil, metrics: nil, exceptions: nil)
    Logger.new(io.flatten, context: context, formatter: formatter, events: events, metrics: metrics, exceptions: exceptions)
  end
end
