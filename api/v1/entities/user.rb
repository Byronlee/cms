module V1
  module Entities
    class User < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id         , documentation: 'not null, primary key'
      expose :name       , documentation: '名字'
      expose :email      , documentation: '邮箱'
      expose :phone      , documentation: '电话'
      expose :tagline    , documentation: ''
      expose :bio        , documentation: ''
      expose :role        , documentation: ''
      expose :avatar_url , documentation: ''
      expose :authentications, using: Entities::Authentication,  documentation: ''

    end
  end
end
