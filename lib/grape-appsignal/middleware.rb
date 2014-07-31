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
        method = env['REQUEST_METHOD']

        request_path = env['api.endpoint'].routes.first.route_path[1..-1].sub(/\(\.:format\)\z/, "")

        metric_name  = "process_action.grape.#{req.request_method}.#{request_path}"
        metric_name = metric_name.gsub(/\/:?/, '.')

        action = "GRAPE#{env['PATH_INFO']}"
        action = action.gsub(/\//, '::')

        ActiveSupport::Notifications.instrument(metric_name, { method: method, path: request_path, action: action, class: "API" } ) do |payload|
          @app.call(env)
        end
      end
    end
  end
end
