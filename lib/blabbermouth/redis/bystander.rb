module Blabbermouth
  module Bystanders
    class Redis < Base
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

      def time(key, duration, *args)
        super
      end

      protected

      def initialize(*args)
        # TODO allow passing redis config arguments through Blabbermouth::Blabber.new
        # TODO should also add default Blabbermouth.configuration.redis config
      end

      def redis
        @redis ||= Redis.new
      end
    end
  end
end
