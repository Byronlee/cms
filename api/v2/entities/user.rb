module V2
  module Entities
    class User < Grape::Entity
      expose :id         , documentation: 'not null, primary key'
      expose :display_name, as: :name   , documentation: '名字'
      expose :avatar, as: :avatar_url , documentation: ''
      expose :sso_id        , documentation: ''
    end
  end
end
