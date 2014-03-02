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
        request_path = env['api.endpoint'].routes.first.route_path[1..-1].gsub(/\(\.:format\)\z/, "")
        metric_name  = "grape.api"
        ActiveSupport::Notifications.instrument(metric_name, method: req.request_method, path: request_path) do
          @app.call(env)
        end
      end
    end
  end
end
