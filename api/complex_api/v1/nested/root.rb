module ComplexAPI
  module V1
    module Nested
      class Root < Grape::API
        prefix 'api/nested'

        mount Stuff
      end
    end
  end
end
