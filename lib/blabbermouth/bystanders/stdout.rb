module Blabbermouth
  module Bystanders
    class Stdout < Base
      def error(key, e, *args)
        data, opts, args = parse_args(*args)
        puts :error, key, e.message, data
      end

      def info(key, msg=nil, *args)
        data, opts, args = parse_args(*args)
        puts :info, key, msg, data
      end

      def increment(key, by=1, *args)
        data, opts, args = parse_args(*args)
        puts :increment, key, by, data
      end

      def count(key, total, *args)
        data, opts, args = parse_args(*args)
        puts :count, key, total, data
      end

      def time(key, value=nil, *args)
        data, opts, args = parse_args(*args)
        puts :time, key, value, data
      end

      protected

      def puts(event, key, msg, data={})
        $stdout.puts log_message(event, key, msg, data)
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
