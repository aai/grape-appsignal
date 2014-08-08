module ComplexAPI
  class Root < Grape::API
    prefix 'api'
    use Appsignal::Grape::Middleware

    mount ::ComplexAPI::V1::Root => '/v1'
  end
end
