module Blabbermouth
  module Bystanders
    class Test < Base
      EVENTS = []

      def self.logged?(event, key, msg)
        EVENTS.any? { |e| e == [event, key, msg] }
      end

      def logged?(event, key, msg)
        self.class.logged? event, key, msg
      end

      def error(key, e, *args)
        data, opts, args = parse_args(*args)
        log :error, key, e.message, data
      end

      def critical(key, e, *args)
        data, opts, args = parse_args(*args)
        log :critical, key, e.message, data
      end

      def warning(key, e=nil, *args)
        data, opts, args = parse_args(*args)
        log :warning, key, e.message, data
      end

      def debug(key, e=nil, *args)
        data, opts, args = parse_args(*args)
        log :debug, key, e.message, data
      end

      def info(key, msg=nil, *args)
        data, opts, args = parse_args(*args)
        log :info, key, msg, data
      end

      def increment(key, by=1, *args)
        data, opts, args = parse_args(*args)
        log :increment, key, by, data
      end

      def count(key, total, *args)
        data, opts, args = parse_args(*args)
        log :count, key, total, data
      end

      def time(key, value=nil, *args)
        data, opts, args = parse_args(*args)
        log :time, key, value, data
      end

      def test(key, msg=nil, *args)
        data, opts, args = parse_args(*args)
        log :test, key, msg, data
      end

      protected

      def log(event, key, msg, data={})
        EVENTS << [event, key, msg]
      end
    end
  end
end
