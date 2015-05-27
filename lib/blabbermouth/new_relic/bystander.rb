module Blabbermouth
  module Bystanders
    class NewRelic < Base
      def error(key, e, *args)
        super
      end

      def info(key, msg=nil, *args)
        super
      end

      def increment(key, by=1, *args)
        super
      end

      def count(key, total, *args)
        super
      end

      def time(key, duration=nil, *args)
        super
      end
    end
  end
end