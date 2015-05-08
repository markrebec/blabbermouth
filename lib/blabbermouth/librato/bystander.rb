module Blabbermouth
  module Bystanders
    class Librato < Base
      def error(key, e, *args)
        data, opts, args = parse_args(*args)
        ::Librato.increment(key, opts)
      end

      def info(key, msg=nil, *args)
        data, opts, args = parse_args(*args)
        begin
          ::Librato::Metrics.annotate(key, msg, opts)
        rescue => e
          STDOUT.puts "[librato] submission failed permanently: #{e.message}"
        end
      end

      def increment(key, by=1, *args)
        data, opts, args = parse_args(*args)
        ::Librato.increment(key, opts.merge({by: by}))
      end

      def count(key, total, *args)
        data, opts, args = parse_args(*args)
        ::Librato.measure(key, total, opts)
      end
      alias_method :gauge, :count

      def time(key, duration, *args)
        data, opts, args = parse_args(*args)
        ::Librato.timing(key, duration, opts)
      end

      def flush
        begin
          ::Librato.tracker.flush
        rescue => e
          false
        end
      end
    end
  end
end
