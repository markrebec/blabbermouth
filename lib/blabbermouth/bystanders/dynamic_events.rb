module Blabbermouth
  module Bystanders
    module DynamicEvents
      EXCLUDES = [:flush]

      def relay(meth, key, *args)
        raise NotImplementedError, "#{self.class.name}##{__method__} has not been implemented"
      end

      def method_missing(meth, *args)
        relay meth, *args
      end

      def respond_to_missing?(meth, include_private=false)
        EXCLUDES.include?(meth) ? false : true
      end
    end
  end
end
