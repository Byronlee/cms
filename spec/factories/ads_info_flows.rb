# == Schema Information
#
# Table name: ads_info_flows
#
#  id           :integer          not null, primary key
#  info_flow_id :integer
#  ad_id        :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ads_info_flow, :class => 'AdsInfoFlows' do
    info_flow_id 1
    ad_id 1
  end
end
