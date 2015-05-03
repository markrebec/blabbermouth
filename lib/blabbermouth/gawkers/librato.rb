module Blabbermouth
  module Gawkers
    class Librato < Base
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

      def flush
        librato!
        begin
          Librato.tracker.flush
        rescue => e
          false
        end
      end

      protected

      def librato?
        defined?(::Librato)
      end

      def librato_metrics?
        librato? && defined?(::Librato::Metrics)
      end

      def librato!
        raise "You must require and configure the librato gem to use it as a gawker" unless librato?
      end

      def librato_metrics!
        raise "You must require and configure the librato_metrics gem to use it as a gawker" unless librato_metrics?
      end
    end
  end
end
