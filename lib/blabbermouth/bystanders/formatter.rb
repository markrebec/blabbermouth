module Blabbermouth
  module Bystanders
    module Formatter
      def timestamp
        ::Time.now.strftime('%Y/%m/%d %H:%M:%S %Z')
      end

      def log_message(event, key, msg, data={})
        message = "[#{timestamp}] Blabbermouth.#{event.to_s}: #{key.to_s}"
        message += ": #{msg.to_s}" unless msg.to_s.blank?
        message += " #{data.to_s}"
        message
      end
    end
  end
end
