# == Schema Information
#
# Table name: ads
#
#  id         :integer          not null, primary key
#  position   :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ad do
    position 2
    content "ad first"
  end

  factory :ad2, class:Ad do
    position 4
    content "ad second"
  end
end