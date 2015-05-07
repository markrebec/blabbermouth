module Blabbermouth
  module Bystanders
    class Rails < Base
      def error(key, e, *args)
        blab :error, key, e, *args
      end

      def info(key, msg=nil, *args)
        blab :info, key, msg, *args
      end

      def increment(key, by=1, *args)
        blab :increment, key, by, *args
      end

      def count(key, total, *args)
        blab :count, key, total, *args
      end

      def time(key, duration, *args)
        blab :time, key, duration, *args
      end

      def blab(meth, key, value, *args)
        data, opts, args = parse_args(*args)
        log meth, key, value, data
      end

      protected

      def rails?
        defined?(::Rails) && ::Rails.respond_to?(:logger)
      end

      def log(event, key, msg, data={})
        message = log_message(event, key, msg, data)
        if event == :error
          rails? ? ::Rails.logger.error(message) : puts(message)
        else
          rails? ? ::Rails.logger.info(message) : puts(message)
        end
      end

      def log_message(event, key, msg, data={})
        message = "[#{::Time.now.strftime('%Y/%m/%d %H:%M:%S %Z')}] Blabbermouth.#{event.to_s}: #{key.to_s}"
        message += ": #{msg.to_s}" unless msg.to_s.blank?
        message += " #{data.to_s}"
        message
      end
    end
  end
end
