require_relative 'mesh'
module API
  class API < Grape::API

    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }

    mount API::V1::Base
    mount API::V2::Base

  end
end
