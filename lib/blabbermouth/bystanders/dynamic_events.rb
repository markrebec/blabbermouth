module Blabbermouth
  module Bystanders
    module DynamicEvents
      EXCLUDES = [:flush]

      def method_missing(meth, *args)
        blab meth, *args
      end

      def respond_to_missing?(meth, include_private=false)
        EXCLUDES.include?(meth) ? false : true
      end
    end
  end
end
