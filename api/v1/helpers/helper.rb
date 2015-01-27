module V1
  module Helpers
    module JSendSuccessFormatter
      def self.call(object, env)
        { status: '200', code: '2001', data: object }.to_json
      end
    end

    module JSendErrorFormatter
      def self.call(message, backtrace, options, env)
        if message.is_a?(Hash)
          { :status => 'fail', :data => message }.to_json
        else
          { :status => 'error', :message => message }.to_json
        end
      end
    end

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
