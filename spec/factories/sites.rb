# == Schema Information
#
# Table name: sites
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  domain       :string(255)
#  info_flow_id :integer
#  admin_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  slug         :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    description "MyText"
    doman "MyString"
  end
end
