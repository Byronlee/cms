#TDOO: DRY
Dir["#{Rails.root}/api/v2/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/controllers/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/entities/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/helpers/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/utils/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/exceptions/*.rb"].each {|file| require file}
Dir["#{Rails.root}/api/v2/validations/*.rb"].each {|file| require file}

module V2
  class Root < API::API
    prefix 'api'
    version 'v2'
    format :json

    helpers V2::APIHelpers
    helpers V2::FormatterHelpers
    helpers V2::ExceptionHelpers

    #formatter :json, V2::FormatterHelpers::JSendSuccessFormatter
    #error_formatter :json, V2::FormatterHelpers::JSendErrorFormatter

    mount API::V2::Posts
    mount API::V2::Columns

    add_swagger_documentation(
      api_version: 'v2', mount_path: 'swagger_doc', hide_documentation_path: true, include_base_url: false
    )

  end
end
