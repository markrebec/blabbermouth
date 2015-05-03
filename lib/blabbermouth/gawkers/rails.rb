module Blabbermouth
  module Gawkers
    class Rails < Base
      def error(key, e, *args, data: {})
        log :error, key, e.message, data
      end

      def info(key, msg=nil, *args, data: {})
        log :info, key, msg, data
      end

      def increment(key, by, *args, data: {})
        log :increment, key, by, data
      end

      def count(key, total, *args, data: {})
        log :count, key, total, data
      end

      def time(key, value=nil, *args, data: {})
        log :time, key, value, data
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
