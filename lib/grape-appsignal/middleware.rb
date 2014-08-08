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

        api_endpoint = env['api.endpoint']
        api_version = api_endpoint.settings[:version].first if api_endpoint.settings[:version] && api_endpoint.settings[:version].first
        api_root_prefix = api_endpoint.settings[:root_prefix] if api_endpoint.settings && api_endpoint.settings[:root_prefix]

        request_path = api_endpoint.routes.first.route_path[1..-1].sub(/\(\.:format\)\z/, "")

        request_path_with_version = request_path.sub /:version/, api_version if api_version

        method_name = "#{method}/#{request_path_with_version || request_path}"

        metric_name  = "process_action.grape.#{req.request_method}.#{request_path}"
        metric_name = metric_name.gsub(/\/:?/, '.')
        metric_name = metric_name.gsub(/:/, '')


        action = "Grape"
        action = action + "(#{api_version})" if api_version
        action = action + "(#{api_root_prefix})" if api_root_prefix
        action = action + "::#{method_name}"

        ActiveSupport::Notifications.instrument(metric_name, { method: method, path: request_path, action: action, class: "API" } ) do |payload|
          @app.call(env)
        end
      end
    end
  end
end
