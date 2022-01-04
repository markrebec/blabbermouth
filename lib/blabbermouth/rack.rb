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
          request = env['blabbermouth.context'] || ActionDispatch::Request.new(env)

          context[:request__method]  = request.method
          context[:request__host]    = request.host
          context[:request__path]    = request.path.split('?').first
          context[:request__format]  = request.format.to_s
          # TODO move param filter to logger/formatter and apply to all messages
          # TODO handle graphql query params a bit better
          context[:request__params]  = PARAM_FILTER.call(request.params)
          context[:request__ip]      = request.remote_ip
          context[:request__session] = request.session.id

          context.compact
        end
      end
    end
  # end
end
