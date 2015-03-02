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

class Ad < ActiveRecord::Base
  has_and_belongs_to_many :info_flows

  validates :position, :content, presence: true
  validates_uniqueness_of :position
end
