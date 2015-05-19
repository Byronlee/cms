# == Schema Information
#
# Table name: fragment_templates
#
#  id           :integer          not null, primary key
#  key          :string(255)
#  name         :string(255)
#  content      :text
#  content_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :fragment_template do
    sequence(:key) { |n| "fragment_#{n}" }
    name { "#{key} name" }
    content { "#{key} content" }
    content_type :plain
  end
end
