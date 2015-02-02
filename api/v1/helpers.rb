module V1
  module Helpers

    module ExceptionHandlers
      def self.included(base)
        base.instance_eval do

          rescue_from Grape::Exceptions::ValidationErrors do |e|
            Rack::Response.new({
              error: { code: 1001, message: e.message }
            }.to_json, e.status)
          end

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

        end
      end
    end
    def attributes_for_keys(keys)
      attrs = {}
      keys.each do |key|
        attrs[key] = params[key] if params[key].present? or (params.has_key?(key) and params[key] == false)
      end
      attrs
    end

  end
end
