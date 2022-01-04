module Blabbermouth
  # module Logging
    module Metric
      def self.new(logger, name=nil, &block)
        name.nil? ? Proxy.new(logger) : Block.new(logger, name).yield(&block)
      end

      class Proxy
        def initialize(logger)
          @logger = logger
        end

        %i(verbose debug info warn error fatal).each do |level|
          define_method level do |name, message=nil, payload={}, force: false, **keyload, &block|
            @logger.metric(name, message, payload, level: level, **keyload, &block)
          end
        end

        def method_missing(meth, *args, &block)
          @logger.send(meth, *args, &block)
        end
      end

      class Block < Proxy
        def initialize(logger, metric)
          super(logger)
          @metric = metric
        end

        def yield(&block)
          yield self
        end

        %i(verbose debug info warn error fatal).each do |level|
          define_method level do |message=nil, payload={}, force: false, **keyload, &block|
            @logger.metric(@metric, message, payload, level: level, **keyload, &block)
          end
        end
      end
    end
  # end
end
