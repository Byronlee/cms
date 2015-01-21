Dir["#{Rails.root}/api/*.rb"].each {|file| require file}

module API
  class API < Grape::API
    version 'v1'
    prefix 'api'
    format :json

    helpers APIHelpers
#    formatter :json, APIHelpers::JSendSuccessFormatter
#    error_formatter :json, APIHelpers::JSendErrorFormatter

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

    mount Posts

    add_swagger_documentation(
      api_version: 'v1', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
    )

  end
end
