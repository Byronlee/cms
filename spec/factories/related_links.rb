# == Schema Information
#
# Table name: related_links
#
#  id          :integer          not null, primary key
#  url         :string(255)
#  link_type   :string(255)
#  title       :string(255)
#  image       :string(255)
#  description :text
#  extra       :text
#  created_at  :datetime
#  updated_at  :datetime
#  post_id     :integer
#  user_id     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :related_link do
    sequence(:url) { |n| "http://36kr.com/related_link_#{n}" }
    sequence(:title) { |n| "title_#{n}" }
    description "this is description"
  end
end
