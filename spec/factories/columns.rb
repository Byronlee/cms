# == Schema Information
#
# Table name: columns
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  introduce   :text
#  created_at  :datetime
#  updated_at  :datetime
#  cover       :string(255)
#  icon        :string(255)
#  posts_count :integer
#  slug        :string(255)
#  order_num   :integer          default(0)
#  extra       :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :column do
    introduce "简介"
    sequence(:name) { |n| "国内创业公司#{n}" }
    sequence(:slug) { |n| "slug#{n}" }
  end

  factory :column2, class: Column do
    name "国外创业公司"
    introduce "简介"
    sequence(:slug) { |n| "slug#{n}" }
  end
end
