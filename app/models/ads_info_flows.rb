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

class AdsInfoFlows < ActiveRecord::Base
end
