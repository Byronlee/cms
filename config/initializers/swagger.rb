GrapeSwaggerRails.options.url      = '/api/v2/doc'
GrapeSwaggerRails.options.app_name = '36krx2015'
GrapeSwaggerRails.options.app_url  = Rails.env.production? ? Settings.site : 'http://localhost:3000'
GrapeSwaggerRails.options.api_auth     = 'api_token'
GrapeSwaggerRails.options.api_key_type = 'query'

GrapeSwaggerRails.options.before_filter do |request|
  # 1. Inspect the `request` or access the Swagger UI controller via `self`.
  # 2. Check `current_user` or `can? :access, :api`, etc.
  # 3. Redirect or error in case of failure.
end
