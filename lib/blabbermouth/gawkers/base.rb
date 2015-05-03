module Blabbermouth
  module Gawkers
    class Base
      def error(key, e, *args, data: {})
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def info(key, msg=nil, *args, data: {})
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def increment(key, by, *args, data: {})
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def count(key, total, *args, data: {})
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def time(key, duration=nil, *args, data: {})
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end
    end
  end
end
