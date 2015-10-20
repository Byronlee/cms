# == Schema Information
#
# Table name: mobile_ads
#
#  id             :integer          not null, primary key
#  ad_title       :string(255)
#  ad_url         :string(255)
#  ad_img_url     :string(255)
#  ad_position    :string(255)
#  ad_enable_time :datetime
#  ad_end_time    :datetime
#  api_count      :integer
#  click_count    :integer
#  ad_summary     :text
#  created_at     :datetime
#  updated_at     :datetime
#

class MobileAd < ActiveRecord::Base

  has_and_belongs_to_many :info_flows

  validates :ad_title, :ad_url, :ad_img_url, :ad_position, presence: true #空判断
  validates_uniqueness_of :ad_img_url  #广告链接唯一

end
