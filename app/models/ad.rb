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

  after_save :update_info_flows_cache
  after_destroy :update_info_flows_cache

  private

  def update_info_flows_cache
    info_flows.each do |info_flow|
      info_flow.update_info_flows_cache
    end
  end
end
