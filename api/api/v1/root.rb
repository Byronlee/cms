class ::API::V1::Root < ::API::BaseAPI
  prefix 'api'
  version 'v1'
  format :json

  helpers ::V1::Helpers
  helpers ::V1::FormatterHelpers
  helpers ::V1::ExceptionHelpers

  #formatter :json, V1::FormatterHelpers::JSendSuccessFormatter
  #error_formatter :json, V1::FormatterHelpers::JSendErrorFormatter

  mount ::API::V1::Posts
  mount ::API::V1::Columns

  add_swagger_documentation(
    api_version: 'v1', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
  )

end
