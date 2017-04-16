module ComplexAPI
  module V1
    module Nested
      class Stuff < Grape::API
        resource :stuff do
          get do
            "stuff #{params['junk']}"
          end
        end
      end
    end
  end
end
