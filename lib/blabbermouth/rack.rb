# frozen_string_literal: true

module Blabbermouth
  # module Logging
    module Rack
      PARAM_FILTER = ->(params) {
        ActiveSupport::ParameterFilter
          .new(Rails.application.config.filter_parameters)
          .filter(params.except('controller', 'action')).to_json.first(2560)
      }

      def initialize(app)
        @app = app
      end

      def call(env)
        Blabbermouth.logger.contextual(context(env)) do
          @app.call(env)
        end
      end

      def context(env)
        env
      end

      class RequestId
        include Rack

        def context(env)
          {
            request__id: env['action_dispatch.request_id']
          }.compact
        end
      end

      class RequestContext
        include Rack

        def context(env)
          context = {}
          request = env['blabbermouth.context']

          # if the application has pre-wrapped a request context for the logger, use it
          if request.present?
            # TODO move this to a RequestContext#to_h or #as_json or #to_context ?
            context = {
              request__host: request.request.host,
              request__type: request.domain.mode,
              request__dnt:  !request.tracking_allowed?
            }

            if request.tracking_allowed?
              context[:request__session]        = request.session_id
              context[:request__ip]             = request.request.remote_ip
              context[:request__country]        = request.origin_country
              context[:request__device]         = request.device_id
              context[:request__device_session] = request.device_session
            end

            if request.referer.present? && request.referer != request.request.host
              context[:request_referer] = request.referer
            end

            if request.ref.present?
              context[:request__ref]      = request.ref
              context[:request__browser]  = request.browser.to_a
            end

            if request.user.present?
              context[:user_id]            = request.user.id
              context[:request__user_id]   = request.user.id

              if request.user.is_a?(::User)
                context[:request__user_type] = request.user.user_type
                context[:request__suppliers] = Array(request.user.suppliers).map(&:identifier).compact
              end
            end
          else # the application has not pre-configured a request context middleware, use defaults
            request = ActionDispatch::Request.new(env)
            context[:request__method]  = request.method
            context[:request__host]    = request.host
            context[:request__path]    = request.path.split('?').first
            context[:request__format]  = request.format.to_s
            # TODO move param filter to logger/formatter and apply to all messages
            context[:request__params]  = PARAM_FILTER.call(request.params)
            context[:request__ip]      = request.remote_ip
            context[:request__session] = request.session.id
          end

          context.compact
        end
      end
    end
  # end
end
