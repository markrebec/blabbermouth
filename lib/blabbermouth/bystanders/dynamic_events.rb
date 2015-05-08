module Blabbermouth
  module Bystanders
    module DynamicEvents

      def method_missing(meth, *args)
        blab meth, *args
      end

      def respond_to_missing?(meth, include_private=false)
        true
      end
    end
  end
end
