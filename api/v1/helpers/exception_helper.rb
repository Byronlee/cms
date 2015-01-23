module V1
  module ExceptionHelpers

    module ExceptionHandlers
      def self.included(base)
        base.instance_eval do
          rescue_from Grape::Exceptions::ValidationErrors do |e|
            Rack::Response.new({
              error: { code: 1001, message: e.message }
            }.to_json, e.status)
          end
        end
      end
    end

  end
end
