# supports chaining logger methods within a log level
#
# example:
#   logger.level(0).debug 'hello world'
module Blabbermouth
  # module Logging
    class Leveled

      def initialize(logger, severity=1)
        @logger = logger
        @severity  = severity
      end

      def level(severity=nil, &block)
        return @severity if severity.nil?
        @logger.level(severity, &block)
      end

      def method_missing(meth, *args, &block)
        @logger.level(@severity) { |l| l.send(meth, *args, &block) }
      end
    end
  # end
end
