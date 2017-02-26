module Test
  class Test < Grape::API

    resource :ping do

      get do
        'pong' 
      end
    end
  end
end
