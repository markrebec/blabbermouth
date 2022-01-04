require 'blabbermouth/formatters/color'
require 'blabbermouth/formatters/json'

module Blabbermouth
  module Formatters
    def self.new(*args)
      Proxy.new(*args)
    end

    class Proxy < Blabbermouth::Proxy
      def initialize(*formatters)
        formatters.push(Blabbermouth::Formatter.new) if formatters.empty?
        super(formatters)
      end

      def call(severity, datetime, progname, message)
        targets.map { |t| t.call(severity, datetime, progname, message) }
      end

      def contextual(context={}, **kontext, &block)
        push_context(context, **kontext)
        yield self
      ensure
        pop_context
      end

      # support ActiveSupport::TaggedLogging when using multiple formatters
      def tagged(*tags, &block)
        new_tags = push_tags(*tags)
        yield self
      ensure
        pop_tags(new_tags.size)
      end
    end
  end
end
