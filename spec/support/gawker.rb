module Blabbermouth
  module Gawkers
    class Test < Base
      EVENTS = []
      attr_reader :events

      def self.logged?(event, key, msg)
        EVENTS.any? { |e| e == [event, key, msg] }
      end

      def logged?(event, key, msg)
        self.class.logged? event, key, msg
      end

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

      def test(key, msg=nil, *args, data: {})
        log :test, key, msg, data
      end

      protected

      def log(event, key, msg, data={})
        EVENTS << [event, key, msg]
      end
    end
  end
end
