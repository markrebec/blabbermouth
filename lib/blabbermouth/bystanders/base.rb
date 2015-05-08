module Blabbermouth
  module Bystanders
    class Base
      def error(key, e, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def info(key, msg=nil, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def increment(key, by=1, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def count(key, total, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def time(key, duration=nil, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      protected

      def initialize(*args)
      end

      # data, opts, args = parse_args(*args)
      # parse_args(*args) { |data, opts, args| ... }
      def parse_args(*args, &block)
        opts = args.extract_options!
        data = opts.delete(:data) || {}
        if block_given?
          yield data, opts, args
        else
          [data, opts, args]
        end
      end
    end
  end
end
