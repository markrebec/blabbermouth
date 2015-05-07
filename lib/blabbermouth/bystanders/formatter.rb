module Blabbermouth
  module Bystanders
    module Formatter
      def log_message(event, key, msg, data={})
        message = "[#{::Time.now.strftime('%Y/%m/%d %H:%M:%S %Z')}] Blabbermouth.#{event.to_s}: #{key.to_s}"
        message += ": #{msg.to_s}" unless msg.to_s.blank?
        message += " #{data.to_s}"
        message
      end
    end
  end
end
