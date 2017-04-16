$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

require 'grape'
require 'grape-appsignal'
require File.expand_path('api/complex_api/v1/hello.rb')
require File.expand_path('api/complex_api/v1/nested/stuff.rb')
require File.expand_path('api/complex_api/v1/nested/root.rb')
require File.expand_path('api/complex_api/v1/root.rb')
require File.expand_path('api/complex_api/root.rb')
