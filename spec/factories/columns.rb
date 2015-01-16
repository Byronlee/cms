# == Schema Information
#
# Table name: columns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  introduce  :text
#  created_at :datetime
#  updated_at :datetime
#  cover      :string(255)
#  icon       :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :column do
    name "MyString"
    introduce "MyText"
  end
end
