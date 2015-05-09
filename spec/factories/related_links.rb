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
    url "MyString"
    title "MyString"
    description "MyText"
  end
end
