Dir["#{Rails.root}/api/*.rb"].each {|file| require file}

module API
  class API < Grape::API
    version 'v1'
    prefix "api"
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      rack_response({'message' => '404 Not found'}.to_json, 404)
    end

    rescue_from :all do |exception|
      trace = exception.backtrace
      message = "\n#{exception.class} (#{exception.message}):\n"
      message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
      message << "  " << trace.join("\n  ")
      API.logger.add Logger::FATAL, message
      rack_response({'message' => '500 Internal Server Error'}, 500)
    end

    helpers APIHelpers

    mount Posts

    add_swagger_documentation(
      mount_path: 'swagger_doc',
      api_version: 'v1',
      hide_documentation_path: true,
      include_base_url: false
    )

  end
end
