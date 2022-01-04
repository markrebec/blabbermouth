# supports chaining together and combining structured logging contexts
#
# example:
#   logger.contextual(foo: :bar).contextual(baz: :qux).info('hello world')
module Blabbermouth
  module Contextual

    def self.new(*args, **opts)
      Proxy.new(*args, **opts)
    end

    def default_context=(context)
      @default_context = Array.wrap(context)
    end

    def default_context
      @default_context ||= []
    end

    def thread_context_key
      @thread_context_key ||= "blabbermouth_logging_context:#{object_id}".freeze
    end

    def thread_context=(context)
      Thread.current[thread_context_key] = Array.wrap(context)
    end

    def thread_context
      Thread.current[thread_context_key] ||= []
    end

    def current_context
      (default_context + thread_context).reduce({}) do |context, ctx|
        ctx = ctx.call if ctx.respond_to?(:call)
        context.merge(ctx)
      end.compact
    end

    class Proxy
      def initialize(logger, context={}, **kontext)
        @logger = logger
        @context = context.merge(kontext)
      end

      def contextual(payload=nil, context={}, **kontext, &block)
        @logger.contextual(payload, @context.merge(context), **kontext, &block)
      end
      alias_method :context, :contextual
      alias_method :with_context, :contextual

      def method_missing(meth, *args, &block)
        @logger.contextual(@context) { |l| l.send(meth, *args, &block) }
      end
    end
  end
end
