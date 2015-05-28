require 'syslog/logger'

module Blabbermouth
  module Bystanders
    class Syslog < Base

      def error(key, e, data: {})
        log(:error, key, e, data)
      end

      def info(key, msg=nil, data: {})
        log(:info, key, msg, data)
      end

      def increment(key, by=1, data: {})
        log(:info, key, increment, data)
      end

      def count(key, total, data: {})
        log(:info, key, total, data)
      end

      def time(key, duration, data: {})
        log(:info, key, duration, data)
      end

      protected

      def syslog
        @syslog ||= Syslog::Logger.new 'blabbermouth'
      end

      def log(event, key, msg, data={})
        level = (event == :error) ? :error : :info
        syslog.send(level, log_message(event, key, msg, data))
      end

    end
  end
end
