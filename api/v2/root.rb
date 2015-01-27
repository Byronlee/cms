Dir["#{Rails.root}/api/v2/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/utils/*.rb"].each {|file| require file}

class ::V2::Root < ::V2::Base
  prefix 'api'
  version 'v2'

  helpers ::V2::Helpers

  #formatter :json, V2::FormatterHelpers::JSendSuccessFormatter
  #error_formatter :json, V2::FormatterHelpers::JSendErrorFormatter

#  mount ::V2::Controllers::Posts
#  mount ::V2::Controllers::Columns
  #helpers ::V2::Helpers

  #formatter :json, ::V2::JSendSuccessFormatter
  #error_formatter :json, ::V2::JSendErrorFormatter

  #mount ::V2::Controllers::Posts
  #mount ::V2::Controllers::Columns

  add_swagger_documentation(
    api_version: 'v2', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
  )

end
