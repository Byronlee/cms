module V1
  module Entities
    class Comment < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      expose :id          , documentation: 'not null, primary key'
      expose :content, as: :body, documentation: '内容'
      expose :user, using: Entities::User, documentation: '用户'
      expose :is_excellent, documentation: ''
      expose :is_long     , documentation: ''
      expose :state       , documentation: ''
      with_options(format_with: :iso_timestamp) do
        expose :created_at  , documentation: ''
        expose :updated_at  , documentation: ''
      end
    end
  end
end
