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
#  state          :boolean          default(FALSE)
#  api_count      :integer          default(0)
#  click_count    :integer          default(0)
#  ad_summary     :text
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mobile_ad do
    ad_title "MyString"
    ad_url "MyString"
    ad_img_url "MyString"
    ad_enable_time "2015-10-20 11:02:47"
    ad_end_time "2015-10-20 11:02:47"
    api_count 1
    click_count 1
  end
end
