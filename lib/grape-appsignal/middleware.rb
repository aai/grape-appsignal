require 'grape'
require 'active_support'

module Appsignal
  module Grape
    class Middleware < ::Grape::Middleware::Base
      def initialize(app)
        @app = app
      end

      def call(env)
        method = env['REQUEST_METHOD']
        metric_path = env['PATH_INFO'].nil? ? ".api" : env['PATH_INFO'].gsub("/", ".")
        request_path = env['api.endpoint'].routes.first.route_path[1..-1].gsub(/\(\.:format\)\z/, "")

        metric_name  = "process_action.grape#{metric_path}"
        action = "#{method}#{env['PATH_INFO']}"

        ActiveSupport::Notifications.instrument(metric_name, { method: method, path: request_path, action: action, class: "API" } ) do |payload|
          @app.call(env)
        end
      end
    end
  end
end
