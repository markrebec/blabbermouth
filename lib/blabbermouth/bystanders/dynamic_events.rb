module Blabbermouth
  module Bystanders
    module DynamicEvents

      def method_missing(meth, *args)
        data = args.extract_options![:data] || {}
        key = args.slice!(0,1).first
        value = args.slice!(0,1).first
        data.merge!({args: args}) unless args.empty?
        blab meth, key, value, data
      end

      def respond_to_missing?(meth, include_private=false)
        true
      end
    end
  end
end
