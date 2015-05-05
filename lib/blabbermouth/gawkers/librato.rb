module Blabbermouth
  module Gawkers
    class Librato < Base
      def error(key, e, *args, data: {})
        librato!
        ::Librato.increment(key)
      end

      def info(key, msg=nil, *args, data: {})
        librato_metrics!
        ::Librato::Metrics.annotate(key, msg)
      end

      def increment(key, by=1, *args, data: {})
        librato!
        ::Librato.increment(key, by: by)
      end

      def count(key, total, *args, data: {})
        librato!
        ::Librato.measure(key, total)
      end
      alias_method :gauge, :count

      def time(key, duration, *args, data: {})
        librato!
        ::Librato.timing(key, duration)
      end

      def flush
        librato!
        begin
          ::Librato.tracker.flush
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
        raise "You must require and configure the librato-metrics gem to use it as a gawker" unless librato?
      end

      def librato_metrics!
        raise "You must require and configure the librato-metrics gem to use it as a gawker" unless librato_metrics?
      end
    end
  end
end
