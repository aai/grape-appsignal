module ComplexAPI
  module V1
    class Hello < Grape::API
      resource :hello do
        get 'name/:name' do
          "hello #{params['name']}"
        end
        get '/goodbye' do
          "hello #{params['name']}"
        end
      end
    end
  end
end
