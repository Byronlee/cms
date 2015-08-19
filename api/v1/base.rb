require_relative 'helpers'
require_relative 'formatter'

class ::V1::Base < Grape::API
  content_type :json, "application/json;charset=UTF-8"
  prefix 'api'
  version 'v1'
  format :json
  #formatter :json, ::V1::JSendSuccessFormatter
  #error_formatter :json, ::V1::JSendErrorFormatter

  # include Grape::Rails::Cache

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
    API::API.logger.info message
    rack_response({message: '500 Internal Server Error', status: 500}, 500)
  end

  before do
    error!("401 Unauthorized", 401) unless authenticated \
      || options[:for] == V1::Controllers::UC \
      || options[:for] == V1::Controllers::Weibo 
#      \
#      || options[:for] == V1::Controllers::Search \
#      || options[:for] == V1::Controllers::Columns \
#      || options[:for] == V1::Controllers::Posts
  end

  helpers ::V1::Helpers

  mount ::V1::Controllers::Users
  mount ::V1::Controllers::Posts
  mount ::V1::Controllers::Search
  mount ::V1::Controllers::UC
  mount ::V1::Controllers::Weibo
  mount ::V1::Controllers::Columns

  add_swagger_documentation(
    api_version: 'v1', mount_path: 'doc',
    hide_documentation_path: true, include_base_url: false
  )

end
