class ::V2::Base < Grape::API

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

end
