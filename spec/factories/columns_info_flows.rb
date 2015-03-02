# == Schema Information
#
# Table name: columns_info_flows
#
#  id           :integer          not null, primary key
#  info_flow_id :integer
#  column_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :columns_info_flow, :class => 'ColumnsInfoFlows' do
    info_flow_id 1
    column_id 1
  end
end
