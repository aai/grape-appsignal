require 'grape'
require 'active_support'

module Appsignal
  module Grape
    class Middleware < ::Grape::Middleware::Base
      def initialize(app)
        @app = app
      end

      def call(env)
        req = ::Rack::Request.new(env)
        metric_action = env['PATH_INFO'].gsub("/", ".")
        request_path = env['api.endpoint'].routes.first.route_path[1..-1].gsub(/\(\.:format\)\z/, "")
        metric_name  = "process_action.api#{metric_action}"
        action = "#{req.request_method}::#{request_path}"
        ActiveSupport::Notifications.instrument(metric_name, { method: req.request_method, path: request_path, action: action } ) do |payload|
          @app.call(env)
        end
      end
    end
  end
end
