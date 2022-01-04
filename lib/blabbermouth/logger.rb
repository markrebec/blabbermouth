module Blabbermouth
  class Logger < ::Logger
    attr_accessor :event_logger, :metric_logger, :exception_logger

    def initialize(logdev, shift_age = 0, shift_size = 1048576, shift_period_suffix: '%Y%m%d', formatter: nil, context: {}, events: nil, metrics: nil, exceptions: nil, **opts)
      super(nil, **opts)

      self.default_context = context
      @default_formatter = Formatters.new

      @logdev = Devices.new(*Array.wrap(logdev), shift_age: shift_age, shift_size: shift_size, shift_period_suffix: shift_period_suffix)
      self.formatter = formatter

      @event_logger = events
      @metric_logger = metrics
      @exception_logger = exceptions
    end

    def formatter=(formatter)
      @formatter = Formatters.new(*Array.wrap(formatter).compact)
    end

    def format_message(severity, datetime, progname, message)
      if contextual?
        format_context(message) do
          message = nil if message.is_a?(Hash)
          super(severity, datetime, progname, message)
        end
      else
        if message.nil? || message.is_a?(Hash)
          message = format_context(message)
        else
          message = format_context(message: message)
        end
        super(severity, datetime, progname, message)
      end
    end

    def format_severity(severity)
      return 'VERBOSE' if severity == VERBOSE
      super
    end


    # Helper Methods verbose, debug, info, warn, error, fatal, exception, event, metric


    # adds support for **keyword arguments to default log level methods
    %i(debug info warn error fatal).each do |level|
      define_method level do |message=nil, force: false, **payload, &block|
        message ||= payload
        if message.is_a?(Hash)
          message = message.reverse_merge(payload)
        else
          message = { message: message }.reverse_merge(payload) if !payload.empty?
        end
        if force
          self.level(level) { super(message, &block) }
        else
          super(message, &block)
        end
      end
    end

    def verbose?; @level <= VERBOSE; end
    def verbose(message=nil, force: false, **payload, &block)
      message ||= payload
      if message.is_a?(Hash)
        message = message.reverse_merge(payload)
      else
        message = { message: message }.reverse_merge(payload) if !payload.empty?
      end
      if force
        level(:verbose) { add(VERBOSE, nil, message, &block) }
      else
        add(VERBOSE, nil, message, &block)
      end
    end

    def event(name=nil, message=nil, payload={}, force: false, **keyload, &block)
      return @event_logger.event(name, message, payload, force: force, **keyload, &block) if @event_logger.present?
      return Event.new(self, name, &block) if name.nil? || block_given?

      payload  = { type: :event, event: name }.merge(payload)
      severity = extract_severity(payload, :info, **keyload)
      contextual(payload, **keyload) { send severity.to_sym, message, force: force }
    end

    def exception(e, payload={}, force: false, **keyload)
      return @exception_logger.exception(e, payload, force: force, **keyload) if @exception_logger.present?

      message  = (e.try(:message) || e)
      payload  = { type: :error, error: e.class.name, backtrace: e.try(:backtrace) }.merge(payload)
      severity = extract_severity(payload, :error, **keyload)
      contextual(payload, **keyload) { send severity.to_sym, message, force: force }
    end
    alias_method :e, :exception

    def metric(name=nil, message=nil, payload={}, force: false, **keyload, &block)
      return @metric_logger.metric(name, message, payload, force: force, **keyload, &block) if @metric_logger.present?
      return Metric.new(self, name, &block) if name.nil? || block_given?

      payload  = { type: :metric, metric: name }.merge(payload)
      severity = extract_severity(payload, :info, **keyload)
      contextual(payload, **keyload) { send severity.to_sym, message, force: force }
    end


    # Level DSL Proxy

    def level=(severity)
      severity = VERBOSE if severity.to_s.downcase == 'verbose'
      super(severity)
    end

    def level(severity=nil)
      original_level = super()
      return original_level if severity.nil?

      unless severity.is_a?(Integer)
        case severity.to_s.downcase
          when 'verbose'
            severity = ::Logger::Severity::VERBOSE
          when 'debug'
            severity = ::Logger::Severity::DEBUG
          when 'info'
            severity = ::Logger::Severity::INFO
          when 'warn'
            severity = ::Logger::Severity::WARN
          when 'error'
            severity = ::Logger::Severity::ERROR
          when 'fatal'
            severity = ::Logger::Severity::FATAL
        end
      end

      if block_given?
        self.level = severity
        begin
          yield self
        ensure
          self.level = original_level
        end
      else
        Leveled.new(self, severity)
      end
    end


    # Contextual Support
    include Contextual

    def current_context
      super.merge(Blabbermouth.current_context)
    end

    def contextual?
      (@formatter || @default_formatter).respond_to?(:contextual)
    end

    def contextual(payload=nil, context={}, **kontext)
      return non_contextual(payload) if !contextual?

      context = payload if context.empty? && payload.is_a?(Hash)
      context = context.merge(kontext)

      if block_given?
        (@formatter || @default_formatter).contextual(context, **{}) { |fmtr| yield self, payload, fmtr }
      elsif payload.present?
        (@formatter || @default_formatter).contextual(context, **{}) { info payload }
      else
        Contextual.new(self, context)
      end
    end
    alias_method :context, :contextual
    alias_method :with_context, :contextual

    private

    # TODO cleanup
    def extract_severity(payload={}, default=:info, **keyload)
      severity   = keyload.delete(:severity) || keyload.delete(:level)
      severity ||= payload.delete(:severity) || payload.delete(:level) || default
    end

    def non_contextual(payload=nil)
      return yield(self, payload) if block_given?
      return info(payload) if payload.present?
      return self
    end

    def format_context(message, **context, &block)
      context = context.merge(message) if message.is_a?(Hash)
      context = context.merge(current_context)
      return context unless block_given?
      contextual(context, **{}) { yield }
    end
  end
end
