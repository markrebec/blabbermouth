module Blabbermouth
  # module Logging
    class Proxy
      attr_reader :targets
      delegate :each, :map, :select, :reject, :find, :first, :last, :[], to: :targets

      def initialize(*targets)
        @targets = targets.flatten # TODO don't flatten (in case you want a proxy of arrays)
      end

      def extend(klass)
        targets.each { |t| t.extend(klass) }
        self
      end

      def method_missing(meth, *args, &block)
        _call(meth, *args, &block).first
      end

      def respond_to_missing?(meth, include_private=true)
        # TODO configure any vs all behavior, and rescuing vs raising in _call
        targets.any? { |t| t.respond_to? meth, include_private }
      end

      def _call(meth, *args, &block)
        Proxy.new(*targets.map { |t| t.send(meth, *args, **{}, &block) rescue nil })
      end
    end
  # end
end
