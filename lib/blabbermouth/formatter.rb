module Blabbermouth
  class Formatter < ::Logger::Formatter
    ORDERED_KEYS = {
      message:  nil,
      event:    nil,
      metric:   nil,
      type:     nil,
      level:    nil,
      duration: nil,
      error:    nil,
    }.freeze

    def call(severity, timestamp, progname, message)
      # format message and context and join them together
      message   = [ format(message), format(context.except(:backtrace)) ].reject(&:blank?).join(" ")
      # call super with formatted message+context
      #formatted = [ super(severity, timestamp, progname, message) ]
      # use simpler formatting as a default (TODO maybe make this an option?)
      formatted = [ "[#{severity}] #{message}\n" ]
      # add a readable backtrace for exceptions if one exists
      formatted.push( "#{backtrace}\n" ) if context.key?(:error) && backtrace.present?
      # print it all out
      formatted.join + "\n"
    end

    def contextual(context={}, **kontext)
      push_context(context, **kontext)
      yield self
    ensure
      pop_context
    end

    private

    def context
      current_context.reduce(&:merge) || {}
    end

    def backtrace
      context[:backtrace].join("\n") if context[:backtrace].present?
    end

    def format(message)
      return message.strip      if message.is_a?(String)
      return message.join(' ')  if message.is_a?(Array)

      if message.is_a?(Enumerable)
        return ORDERED_KEYS.merge(message.to_h).compact.map do |key,val|
          formatted = format(val)

          if val.is_a?(Array)
            formatted = "(#{formatted})"
          elsif val.is_a?(Enumerable)
            formatted = "<#{formatted}>"
          end

          "#{key}=#{formatted}"
        end.join(' ')
      end

      message.to_s.strip
    end

    def current_context
      context_thread_key = @context_thread_key ||= "blabbermouth_logging_context:#{object_id}".freeze
      Thread.current[context_thread_key] ||= []
    end

    def push_context(context={}, **kontext)
      current_context.push(context.merge(kontext))
    end

    def pop_context
      current_context.pop
    end

  end
end
