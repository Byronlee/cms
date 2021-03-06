# == Schema Information
#
# Table name: mobile_ads
#
#  id             :integer          not null, primary key
#  ad_title       :string(255)
#  ad_url         :text
#  ad_img_url     :string(255)
#  ad_position    :string(255)
#  ad_enable_time :datetime
#  ad_end_time    :datetime
#  state          :boolean          default(FALSE)
#  ad_type        :integer          default(0)
#  api_count      :integer          default(0)
#  click_count    :integer          default(0)
#  ad_summary     :text
#  created_at     :datetime
#  updated_at     :datetime
#

class MobileAd < ActiveRecord::Base

  #has_and_belongs_to_many :info_flows

  validates :ad_title, :ad_url, :ad_img_url, :ad_position, presence: true #空判断
  validates_uniqueness_of :ad_img_url

  #scope :published, -> { where(state: true) }
  scope :recent,    -> { order('ad_enable_time desc') }

  page_view_field :api_count, interval: 1800
  page_view_field :click_count, interval: 1800

end
