module V1
  module Entities
    class User < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id         , documentation: 'not null, primary key'
      expose :email      , documentation: '邮箱'
      expose :phone      , documentation: '电话'

    end
  end
end
