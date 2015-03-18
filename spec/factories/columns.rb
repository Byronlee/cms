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
#  order_num   :string(255)      default("0")
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :column do
    name "国内创业公司"
    introduce "简介"
    slug "cn-startups"
  end

  factory :column2, class:Column do
    name "国外创业公司"
    introduce "简介"
    slug "us-startups"
  end
end
