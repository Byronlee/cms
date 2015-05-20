module V2
  module Entities
    class UserDetail < ::V2::Entities::User
      format_with(:iso_timestamp) { |dt| dt.iso8601 if dt }
      expose :email      , documentation: '邮箱'
      expose :phone      , documentation: '电话'
      expose :tagline    , documentation: ''
      expose :bio        , documentation: ''
      expose :role        , documentation: ''
      expose :authentication_token , documentation: ''
      expose :authentications, using: Entities::Authentication,  documentation: ''
      with_options(format_with: :iso_timestamp) do
        expose :created_at,       documentation: ''
        expose :updated_at,       documentation: ''
      end
    end
  end
end
