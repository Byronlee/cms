# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  is_excellent     :boolean
#  is_long          :boolean
#  state            :string(255)
#
module V1
  module Entities
    class Comment < Grape::Entity
      format_with(:iso8601) {|t| t.iso8601 if t }
      expose :id          , documentation: 'not null, primary key'
      expose :content     , documentation: '内容'
#      expose :user_id     , documentation: '用户'
      expose :user, using: Entities::User, documentation: '用户'
      expose :created_at  , documentation: ''
      expose :updated_at  , documentation: ''
      expose :is_excellent, documentation: ''
      expose :is_long     , documentation: ''
      expose :state       , documentation: ''
    end
  end
end
