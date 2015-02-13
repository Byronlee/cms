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

class Ad < ActiveRecord::Base
  has_and_belongs_to_many :info_flows
end
