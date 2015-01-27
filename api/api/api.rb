module API
  class API < Grape::API

    mount API::V1::Root

  end
end
