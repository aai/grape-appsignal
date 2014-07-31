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


        method_name = api_endpoint.method_name.gsub(/ ?[ \/]/, '/') if api_endpoint && api_endpoint.method_name
        method_name = method_name.gsub(/\/\//, '/') if method_name

        request_path = api_endpoint.routes.first.route_path[1..-1].sub(/\(\.:format\)\z/, "")

        metric_name  = "process_action.grape.#{req.request_method}.#{request_path}"
        metric_name = metric_name.gsub(/\/:?/, '.')

        action = "Grape"
        action = action + "(#{api_endpoint.settings[:version].first})" if
          api_endpoint.settings[:version] && api_endpoint.settings[:version].first
        action = action + "(#{api_endpoint.settings[:root_prefix]})" if
          api_endpoint.settings  && api_endpoint.settings[:root_prefix]

        action = action + "::#{method_name}"
        #action = action.gsub(/  ?/, '/')

        ActiveSupport::Notifications.instrument(metric_name, { method: method, path: request_path, action: action, class: "API" } ) do |payload|
          @app.call(env)
        end
      end
    end
  end
end
