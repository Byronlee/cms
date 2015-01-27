module API
  class API2 < Grape::API

    mount API::V1::Root

  end
end
