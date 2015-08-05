# == Schema Information
#
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
#  email            :string(255)
#  ancestry         :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user
    content 'MyText'

    association :commentable, factory: :post
  end
end
