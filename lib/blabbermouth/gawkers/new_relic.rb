module Blabbermouth
  module Gawkers
    class NewRelic < Base
      def error(key, e, *args, data: {})
        super
      end

      def info(key, msg=nil, *args, data: {})
        super
      end

      def increment(key, count, *args, data: {})
        super
      end

      def count(key, total, *args, data: {})
        super
      end

      def time(key, duration=nil, *args, data: {})
        super
      end

      protected

      def new_relic?
        defined?(::NewRelic)
      end

      def new_relic!
        raise "You must require and configure the newrelic_rpm gem to use it as a gawker" unless new_relic?
      end
    end
  end
end
