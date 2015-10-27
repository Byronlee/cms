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

require 'spec_helper'

describe MobileAd do
  pending "add some examples to (or delete) #{__FILE__}"
end
