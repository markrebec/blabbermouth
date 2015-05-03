require 'blabbermouth/exceptions'

module Blabbermouth
  module Gawkers
    class Rollbar < Base

      def error(key, e, *args, data: {})
        rollbar!
        ::Rollbar.error(Blabbermouth::Error.new(key, e), data)
      end

      def info(key, msg=nil, *args, data: {})
        rollbar!
        ::Rollbar.info(Blabbermouth::Info.new(key, msg), data)
      end

      def increment(key, by, *args, data: {})
        rollbar!
        ::Rollbar.info(Blabbermouth::Increment.new(key, by), data)
      end

      def count(key, total, *args, data: {})
        rollbar!
        ::Rollbar.info(Blabbermouth::Count.new(key, total), data)
      end

      def time(key, duration, *args, data: {})
        rollbar!
        ::Rollbar.info(Blabbermouth::Time.new(key, duration), data)
      end

      protected

      def rollbar?
        defined?(::Rollbar)
      end

      def rollbar!
        raise "You must require and configure the rollbar gem to use it as a gawker" unless rollbar?
      end
    end
  end
end
