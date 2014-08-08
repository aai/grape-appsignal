module ComplexAPI
  module V1
    class Root < Grape::API
      version 'v1', using: :path

      mount ::ComplexAPI::V1::Hello
      mount ::ComplexAPI::V1::Nested::Root
    end
  end
end
