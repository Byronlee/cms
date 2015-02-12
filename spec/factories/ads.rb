# == Schema Information
#
# Table name: ads
#
#  id         :integer          not null, primary key
#  position   :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ad do
    position "MyString"
    content "MyText"
  end
end
