class ::V1::Root < ::V1::Base
  prefix 'api'
  version 'v1'

  helpers ::V1::Helpers

  #formatter :json, V1::FormatterHelpers::JSendSuccessFormatter
  #error_formatter :json, V1::FormatterHelpers::JSendErrorFormatter

  mount ::V1::Controllers::Posts
  mount ::V1::Controllers::Columns

  add_swagger_documentation(
    api_version: 'v1', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
  )

end
