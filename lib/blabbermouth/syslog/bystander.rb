require 'syslog/logger'

module Blabbermouth
  module Bystanders
    class Syslog < Base
      include Blabbermouth::Bystanders::Formatter
      include Blabbermouth::Bystanders::DynamicEvents

      LOG_LEVELS = [:debug, :error, :fatal, :info, :unknown, :warn]

      def debug(key, msg=nil, *args)
        relay :debug, key, msg, *args
      end

      def error(key, e, *args)
        relay :error, key, e, *args
      end

      def fatal(key, e, *args)
        relay :fatal, key, e, *args
      end
      alias_method :critical, :fatal

      def info(key, msg=nil, *args)
        relay :info, key, msg, *args
      end

      def unknown(key, msg=nil, *args)
        relay :unknown, key, msg, *args
      end

      def warn(key, msg=nil, *args)
        relay :warn, key, msg, *args
      end
      alias_method :warning, :warn

      def time(key, duration, *args)
        relay :time, key, duration, *args
      end

      def count(key, total, *args)
        relay :count, key, total, *args
      end

      def increment(key, by=1, *args)
        relay :increment, key, by, *args
      end

      def relay(meth, key, *args)
        data, opts, args = parse_args(*args)
        log meth, key, args.first, data
      end

      def log_message(event, key, msg, data={})
        message = "Blabbermouth.#{event.to_s}: #{key.to_s}"
        message += ": #{msg.to_s}" unless msg.to_s.blank?
        message += " #{data.to_s}"
        message
      end

      protected

      def syslog
        @syslog ||= ::Syslog::Logger.new 'blabbermouth'
      end

      def log(event, key, msg, data={})
        level = (LOG_LEVELS.include?(event)) ? event : :info
        syslog.send(level, log_message(event, key, msg, data))
      end

    end
  end
end
