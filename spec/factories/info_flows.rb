# == Schema Information
#
# Table name: info_flows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :info_flow do
    name "info_flow 1"
  end

  factory :info_flow2, class:InfoFlow do
    name "info_flow 2"
  end

  factory :main_site, class:InfoFlow do
    name "主站"
  end
end
