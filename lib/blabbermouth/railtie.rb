require 'blabbermouth/rack'

module Blabbermouth
  # module Logging
    class Railtie < Rails::Railtie
      def unsubscribe(component, subscriber)
        events = subscriber.public_methods(false).reject { |method| method.to_s == 'call' }
        events.each do |event|
          ActiveSupport::Notifications.notifier.listeners_for("#{event}.#{component}").each do |listener|
            if listener.instance_variable_get('@delegate') == subscriber
              ActiveSupport::Notifications.unsubscribe listener
            end
          end
        end
      end

      # set up some defaults before application/environment config
      config.before_configuration do |app|
        Rails.configuration.log_level     = ENV.fetch('LOG_LEVEL', 'info').downcase.to_sym
        Rails.configuration.log_format    = ENV.fetch('LOG_FORMAT', 'json').downcase.to_sym
        Rails.configuration.log_formatter = nil # unset active support's default SimpleFormatter
        Rails.configuration.log_output    = begin
          # if you need something other than a constant (like STDOUT/STDERR) or a string pointing
          # at a file/io device (like 'log/development.log' or '/dev/null'), you can configure a
          # custom output in your application or environment config files:
          #
          # config.log_output = CustomIO.new
          #
          output = ENV.fetch('LOG_OUTPUT', 'STDOUT')
          output = output.upcase.safe_constantize if %w(STDOUT STDERR).include?(output.upcase)
          output
        end
        Rails.configuration.event_logger = nil
        Rails.configuration.metric_logger = nil
        Rails.configuration.exception_logger = nil
      end

      # hook in right before active support takes over to configure the logger and set
      # one first based on application configuration
      initializer :initialize_blabbermouth, group: :all, before: :initialize_logger do |app|
        # use the provided logger if configured
        Rails.logger ||= app.config.logger
        # otherwise create one based on config
        Rails.logger ||= Blabbermouth.logger ||= begin
          # map any configured formatters to their class
          formatters = Array.wrap(app.config.log_format).map do |lf|
            case lf.to_s.downcase
              when 'json'
                Formatters::JSON.new
              when 'color'
                Formatters::Color.new
              else
                Formatter.new
            end
          end

          # create a new logger with the configured outputs and formatters
          logger = Blabbermouth::Logger.new(
            app.config.log_output,
            formatter: formatters,
            events: app.config.event_logger,
            metrics: app.config.metric_logger,
            exceptions: app.config.exception_logger
          )

          # set the formatter if a custom formatter is configured
          logger.formatter = app.config.log_formatter if app.config.log_formatter.present?

          # wrap with tagged logging for rails/active support
          logger = ActiveSupport::TaggedLogging.new(logger)

          logger
        end

        # set the configured log level
        Rails.logger.level = app.config.log_level
      end

      initializer :blabbermouth_rack_middleware, group: :all do |app|
        # removes default rails logger middleware
        app.config.middleware.delete       Rails::Rack::Logger
        # configures rack middleware for global request context
        app.config.middleware.use          Blabbermouth::Rack::RequestContext
        app.config.middleware.insert_after ActionDispatch::RequestId, Blabbermouth::Rack::RequestId
      end

      config.after_initialize do |app|

        # unsubscribe the default ActionView and ActionController log subscribers
        # and hook in with our own
        ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
          case subscriber
          when ActionView::LogSubscriber
            unsubscribe(:action_view, subscriber)
          when ActionController::LogSubscriber
            unsubscribe(:action_controller, subscriber)
          when ActiveRecord::LogSubscriber
            unsubscribe(:active_record, subscriber)
          # TODO handle this more gracefull if no elasticsearch
          # when Elasticsearch::Rails::Instrumentation::LogSubscriber
          #   unsubscribe(:elasticsearch, subscriber)
          end
        end

        # TODO MARK move/reogranize all this and clean it up
        ActiveSupport::Notifications.subscribe 'render_template.action_view' do |name, start, finish, id, payload|
          # TODO better event severity
          Rails.logger.event name, duration: ((finish - start) * 1000.0), template: payload[:identifier], layout: payload[:layout], severity: :debug
        end

        ActiveSupport::Notifications.subscribe 'render_partial.action_view' do |name, start, finish, id, payload|
          # TODO event severity
          Rails.logger.event name, duration: ((finish - start) * 1000.0), template: payload[:identifier], severity: :debug
        end

        # ActiveSupport::Notifications.subscribe 'search.elasticsearch' do |name, start, finish, id, payload|
        #   # TODO better event severity
        #   payload[:search] = payload[:search].to_json
        #   Rails.logger.event name, duration: ((finish - start) * 1000.0), severity: :debug, **payload
        # end

        ActiveSupport::Notifications.subscribe 'sql.active_record' do |name, start, finish, id, payload|
          ActiveRecord::LogSubscriber.runtime += ((finish - start) * 1000.0)
          unless payload[:name] == 'SCHEMA' || payload[:sql].match?(/^(BEGIN|COMMIT|ROLLBACK)/)
            stack = caller
              .select { |l| l.include?(Rails.root.to_s) }
              .map { |l| l.gsub(Rails.root.to_s, '.').split(':')[0..1].join(':') }
              .slice(0..5)
            # TODO better event severity
            Rails.logger.event name, duration: ((finish - start) * 1000.0), backtrace: stack, severity: :debug, **payload.except(:connection, :binds)
          end
        end

        ActiveSupport::Notifications.subscribe 'start_processing.action_controller' do |_name, start, finish, _id, payload|
          controller = payload[:controller].underscore
          action     = payload[:action]

          context = {
            'request__route':         [controller, action].join('#'),
            'request__controller':    controller,
            'request__action':        action,
            'request__method':        payload[:method],
            'request__format':        payload[:format],
            'request__path':          payload[:path]
          }.compact

          Rails.logger.event 'http.request.start', "#{payload[:method]} #{payload[:path]} #{payload[:format].upcase}", context
        end

        ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |_name, start, finish, _id, payload|
          controller = payload[:controller].underscore
          action     = payload[:action]

          context = {
            'request__method':        payload[:method],
            'request__format':        payload[:format],
            'request__path':          payload[:path],
            'request__status':        payload[:status] || 500,
            'request__route':         [controller, action].join('#'),
            'request__controller':    controller,
            'request__action':        action,
            'request__view_runtime':  payload[:view_runtime],
            'request__db_runtime':    payload[:db_runtime],
            'request__duration':      (finish - start) * 1000.0,
            'duration':               (finish - start) * 1000.0
          }.compact

          if payload[:exception].present?
            context['request__exception']     = payload[:exception].first
            context['request__exception_msg'] = payload[:exception].last
            context['exception'] = payload[:exception].first
            context['message']   = payload[:exception].last
          end

          Rails.logger.event 'http.request.done', "#{payload[:method]} #{payload[:path]} #{payload[:format].upcase}", context
          #Rails.logger.event :http_request, context
        end
      end
    end
  # end
end
