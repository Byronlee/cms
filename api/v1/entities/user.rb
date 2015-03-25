module V1
  module Entities
    class User < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      expose :id         , documentation: 'not null, primary key'
      expose :display_name, as: :name   , documentation: '名字'
      expose :email      , documentation: '邮箱'
      expose :phone      , documentation: '电话'
      expose :tagline    , documentation: ''
      expose :bio        , documentation: ''
      expose :role        , documentation: ''
      expose :sso_id        , documentation: ''
      expose :avatar, as: :avatar_url , documentation: ''
      expose :authentication_token , documentation: ''
      expose :authentications, using: Entities::Authentication,  documentation: ''
      with_options(format_with: :iso_timestamp) do
        expose :created_at , documentation: ''
        expose :updated_at , documentation: ''
      end
    end
  end
end
