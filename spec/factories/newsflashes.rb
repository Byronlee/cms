# == Schema Information
#
# Table name: newsflashes
#
#  id                       :integer          not null, primary key
#  original_input           :text
#  hash_title               :string(255)
#  description_text         :text
#  news_url                 :string(255)
#  newsflash_topic_color_id :integer
#  news_summaries           :string(8000)
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  cover                    :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsflash do
    original_input <<-MARKDOWN
#36氪号称全球最牛逼的科技媒体公司今天上市#根据本报讯，今天上午全球最牛逼的科技媒体公司36氪在拉斯维达斯成功上市，市值一只飙升1一千亿美元 http://36kr.com

---------------------------------------

1. 36氪最牛逼

2. 36氪今天上市

3. 36氪所有员工都很牛逼
  MARKDOWN
  end
end
