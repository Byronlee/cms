require_relative 'mesh'
require_relative 'errors'
require_relative 'helpers'
require_relative 'validations'
require_relative 'formatter'

class ::V1::Base < Grape::API
  prefix 'api'
  version 'v1'

  helpers ::V1::Helpers

  #formatter :json, ::V1::JSendSuccessFormatter
  #error_formatter :json, ::V1::JSendErrorFormatter

  include ::V1::ExceptionHandlers

  mount ::V1::Controllers::Users
  mount ::V1::Controllers::Posts
  mount ::V1::Controllers::Columns

  add_swagger_documentation(
    api_version: 'v1', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
  )

end
