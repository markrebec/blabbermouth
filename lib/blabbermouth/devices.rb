module Blabbermouth
  # module Logging
    class Devices < Proxy
      def initialize(*ios, **opts)
        super(*ios.map { |io| ::Logger::LogDevice.new(io, **opts) })
      end

      def write(*messages)
        messages = messages.flatten
        return if messages.empty?

        if messages.length <= targets.length
          # loop through targets, potentially re-using or leaving out messages
          #   good for loggers with one formatter and multiple devices
          m = 0
          targets.map do |target|
            written = target.write(messages[m])
            m = m+1
            m = 0 if m >= messages.length
            written
          end
        else
          # loop through messages, potentially re-using or leaving out targets
          #   good for loggers with one device looking to output multiple formatted versions of messages
          t = 0
          messages.each do |message|
            written = targets[t].write(message)
            t = t+1
            t = 0 if t >= targets.length
            written
          end
        end
      end
    end
  # end
end
