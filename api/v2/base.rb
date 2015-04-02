require_relative 'errors'
require_relative 'helpers'
require_relative 'formatter'
require_relative 'passport'

class ::V2::Base < Grape::API
  content_type :json, "application/json;charset=UTF-8"
  prefix 'api'
  version 'v2'
  #format :json
  #formatter :json, ::V2::JSendSuccessFormatter
  #error_formatter :json, ::V2::JSendErrorFormatter

  rescue_from ActiveRecord::RecordNotFound do
    rack_response({message: '404 Not found !', status: 404}, 404)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error_response(message: e.message, status: 406)
  end

  rescue_from :all do |exception|
    trace = exception.backtrace
    message = "\n#{exception.class} (#{exception.message}):\n"
    message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
    message << "  " << trace.join("\n  ")
    #API.logger.add Logger::FATAL, message
    rack_response({message: '500 Internal Server Error', status: 500}, 500)
  end

  before do
    error!("401 Unauthorized", 401) unless authenticated
  end

  helpers ::V2::Helpers

  mount ::V2::Controllers::Users
  mount ::V2::Controllers::Posts
  mount ::V2::Controllers::Columns
  mount ::V2::Controllers::Comments
  mount ::V2::Controllers::HeadLines

  add_swagger_documentation(
    api_version: 'v2', mount_path: 'swagger_doc',
    hide_documentation_path: true, include_base_url: false
  )

end
