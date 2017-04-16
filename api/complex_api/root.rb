module ComplexAPI
  class Root < Grape::API
    prefix 'api'
    use Appsignal::Grape::Middleware

    mount ::ComplexAPI::V1::Root
  end
end
