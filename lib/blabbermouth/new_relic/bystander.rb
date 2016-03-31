module Blabbermouth
  module Bystanders
    class NewRelic < Base
      def error(key, e, *args)
        ::NewRelic::Agent.notice_error(e, (args.extract_options! || {}).merge(key: key))
      end

      def info(key, msg=nil, *args)
        ::NewRelic::Agent.record_custom_event(key, (args.extract_options! || {}).merge({message: msg}))
      end

      def increment(key, by=1, *args)
        ::NewRelic::Agent.increment_metric(key, by)
      end

      def count(key, total, *args)
        ::NewRelic::Agent.record_metric(key, total)
      end

      def time(key, duration=nil, *args)
        ::NewRelic::Agent.record_custom_event(key, (args.extract_options! || {}).merge({duration: duration}))
      end
    end
  end
end
