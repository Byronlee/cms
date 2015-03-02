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

class ColumnsInfoFlows < ActiveRecord::Base
end
