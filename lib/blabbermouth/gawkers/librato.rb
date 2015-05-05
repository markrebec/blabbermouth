module Blabbermouth
  module Gawkers
    class Librato < Base
      def error(key, e, *args)
        data, opts, args = parse_args(*args)
        librato!
        ::Librato.increment(key, opts)
      end

      def info(key, msg=nil, *args)
        data, opts, args = parse_args(*args)
        librato_metrics!
        begin
          ::Librato::Metrics.annotate(key, msg, opts)
        rescue => e
          STDOUT.puts "[librato] submission failed permanently: #{e.message}"
        end
      end

      def increment(key, by=1, *args)
        data, opts, args = parse_args(*args)
        librato!
        ::Librato.increment(key, opts.merge({by: by}))
      end

      def count(key, total, *args)
        data, opts, args = parse_args(*args)
        librato!
        ::Librato.measure(key, total, opts)
      end
      alias_method :gauge, :count

      def time(key, duration, *args)
        data, opts, args = parse_args(*args)
        librato!
        ::Librato.timing(key, duration, opts)
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
