module Blabbermouth
  module Bystanders
    class Stdout < Base
      include Blabbermouth::Bystanders::Formatter
      include Blabbermouth::Bystanders::DynamicEvents

      def error(key, e, *args)
        relay :error, key, e, *args
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
        puts meth, key, args.first, data
      end

      protected

      def puts(event, key, msg, data={})
        $stdout.puts log_message(event, key, msg, data)
      end
    end
  end
end
