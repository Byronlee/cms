Dir["#{Rails.root}/api/v2/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/utils/*.rb"].each {|file| require file}

class ::V2::Base < Grape::API
  prefix 'api'
  version 'v2'

  #helpers ::V2::Helpers

  rescue_from ActiveRecord::RecordNotFound do
    rack_response({message: '404 Not found', status: 404}, 404)
  end

  rescue_from :all do |exception|
    trace = exception.backtrace
    message = "\n#{exception.class} (#{exception.message}):\n"
    message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
    message << "  " << trace.join("\n  ")
    API.logger.add Logger::FATAL, message
    rack_response({message: '500 Internal Server Error', status: 500}, 500)
  end

  #formatter :json, ::V2::JSendSuccessFormatter
  #error_formatter :json, ::V2::JSendErrorFormatter

  #mount ::V2::Controllers::Posts
  #mount ::V2::Controllers::Columns

  add_swagger_documentation(
    api_version: 'v2', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
  )

end
