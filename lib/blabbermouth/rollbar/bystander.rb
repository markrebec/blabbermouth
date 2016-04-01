require 'blabbermouth/exceptions'

module Blabbermouth
  module Bystanders
    class Rollbar < Base
      def error(key, e, data: {})
        ::Rollbar.error(Blabbermouth::Error.new(key, e), data)
      end

      def critical(key, e, data: {})
        ::Rollbar.critical(Blabbermouth::Critical.new(key, e), data)
      end

      def debug(key, e=nil, data: {})
        ::Rollbar.debug(Blabbermouth::Debug.new(key, e), data)
      end

      def warning(key, e=nil, data: {})
        ::Rollbar.warning(Blabbermouth::Warning.new(key, e), data)
      end

      def info(key, msg=nil, data: {})
        ::Rollbar.info(Blabbermouth::Info.new(key, msg), data)
      end

      def increment(key, by=1, data: {})
        ::Rollbar.info(Blabbermouth::Increment.new(key, by), data)
      end

      def count(key, total, data: {})
        ::Rollbar.info(Blabbermouth::Count.new(key, total), data)
      end

      def time(key, duration, data: {})
        ::Rollbar.info(Blabbermouth::Time.new(key, duration), data)
      end
    end
  end
end
