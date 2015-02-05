require_relative 'mesh'
require_relative 'errors'
require_relative 'helpers'
require_relative 'formatter'

class ::V1::Base < Grape::API
  prefix 'api'
  version 'v1'
  #format :json
  #formatter :json, ::V1::JSendSuccessFormatter
  #error_formatter :json, ::V1::JSendErrorFormatter

  rescue_from ActiveRecord::RecordNotFound do
    rack_response({message: '404 Not found !', status: 404}, 404)
  end

  rescue_from :all do |exception|
    trace = exception.backtrace
    message = "\n#{exception.class} (#{exception.message}):\n"
    message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
    message << "  " << trace.join("\n  ")
    API.logger.add Logger::FATAL, message
    #rack_response({message: '500 Internal Server Error', status: 500}, 500)
  end

  helpers ::V1::Helpers

  mount ::V1::Controllers::Users
  mount ::V1::Controllers::Posts
  mount ::V1::Controllers::Columns
  mount ::V1::Controllers::HeadLines

  add_swagger_documentation(
    api_version: 'v1', mount_path: 'swagger_doc',
    hide_documentation_path: true, include_base_url: false
  )

end
