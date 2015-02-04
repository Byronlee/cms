# == Schema Information
#
# Table name: newsflash_topic_colors
#
#  id         :integer          not null, primary key
#  site_name  :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsflash_topic_color do
    site_name "MyString"
    color "MyString"
  end
end
