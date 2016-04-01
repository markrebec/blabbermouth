module Blabbermouth
  module Bystanders
    class Rails < Base
      include Blabbermouth::Bystanders::Formatter
      include Blabbermouth::Bystanders::DynamicEvents

      def error(key, e, *args)
        relay :error, key, e, *args
      end

      def critical(key, e, *args)
        relay :critical, key, e, *args
      end

      def warning(key, e=nil, *args)
        relay :warning, key, e, *args
      end

      def debug(key, e=nil, *args)
        relay :debug, key, e, *args
      end

      def info(key, msg=nil, *args)
        relay :info, key, msg, *args
      end

      def increment(key, by=1, *args)
        relay :increment, key, by, *args
      end

      def count(key, total, *args)
        relay :count, key, total, *args
      end

      def time(key, duration, *args)
        relay :time, key, duration, *args
      end

      def relay(meth, key, *args)
        data, opts, args = parse_args(*args)
        log meth, key, args.first, data
      end

      protected

      def log(event, key, msg, data={})
        message = log_message(event, key, msg, data)
        if [:error, :critical].include?(event)
          ::Rails.logger.error(message)
        else
          ::Rails.logger.info(message)
        end
      end
    end
  end
end
