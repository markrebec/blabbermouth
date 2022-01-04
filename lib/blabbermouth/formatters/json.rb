module Blabbermouth
  # module Logging
    module Formatters
      class JSON < Blabbermouth::Formatter

        def call(severity, timestamp, _progname, message)
          # ensure message is structured
          message = {} if message.blank?
          message = { message: message } unless message.is_a?(Hash)

          # merge in defaults and context
          message = {
            type: :log,
            level: severity,
            '@timestamp': timestamp,
            epoch: (timestamp.to_f * 1000).to_i
          }.merge(message).merge(context)

          # merge in tags if tagged logging is supported
          message.merge!(tags: current_tags) if respond_to?(:current_tags)

          # format and print it all out as JSON
          "#{format(message).to_json}\n"
        end

        def format(message)
          return message.strip    if message.is_a?(String)
          return message.as_json  if message.is_a?(Array)

          if message.is_a?(Enumerable)
            return message.to_h.map do |key,val|
              [key, format(val)]
            end.to_h.as_json
          end

          message.as_json
        end

      end
    end
  # end
end
