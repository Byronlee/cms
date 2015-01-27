module V1
  module Exceptions

    # code: api error code defined by 36kr by xiaobo, errors originated from
    # subclasses of Error have code start from 2000.
    # text: human readable error message
    # status: http status code
    class Error < Grape::Exceptions::Base
      attr :code, :text
      def initialize(opts={})
        @code    = opts[:code]   || 2000
        @text    = opts[:text]   || ''
        @status  = opts[:status] || 400
        @message = {error: {code: @code, message: @text}}
      end
    end

    class AuthorizationError < Error
      def initialize
        super code: 2001, text: 'Authorization failed', status: 401
      end
    end

    class CreatePostError < Error
      def initialize(e)
        super code: 2002, text: "Failed to create post. Reason: #{e}", status: 400
      end
    end

    class CancelPostError < Error
      def initialize(e)
        super code: 2003, text: "Failed to cancel post. Reason: #{e}", status: 400
      end
    end

    class NotFoundError < Error
      def initialize(id)
        super code: 2004, text: "Order##{id} doesn't exist.", status: 404
      end
    end

    class IncorrectSignatureError < Error
      def initialize(signature)
        super code: 2005, text: "Signature #{signature} is incorrect.", status: 401
      end
    end

    class InvalidAccessKeyError < Error
      def initialize(access_key)
        super code: 2008, text: "The access key #{access_key} does not exist.", status: 401
      end
    end

    class DisabledAccessKeyError < Error
      def initialize(access_key)
        super code: 2009, text: "The access key #{access_key} is disabled.", status: 401
      end
    end

    class ExpiredAccessKeyError < Error
      def initialize(access_key)
        super code: 2010, text: "The access key #{access_key} has expired.", status: 401
      end
    end

    class OutOfScopeError < Error
      def initialize
        super code: 2011, text: "Requested API is out of access key scopes.", status: 401
      end
    end

  end
end
