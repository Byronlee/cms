module V1
  module FormatterHelpers

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

  end
end
