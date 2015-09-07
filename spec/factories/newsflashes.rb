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
#  is_top                   :boolean          default(FALSE)
#  toped_at                 :datetime
#  views_count              :integer          default(0)
#  column_id                :integer
#  extra                    :text
#  display_in_infoflow      :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsflash do
    # sequence(:original_input) { |n| "#36氪号称全球最牛逼的科技媒体公司今#{n}天上市#根据本报讯，今天上午全球最牛逼的科技媒体公司36氪在拉斯维达斯成功上市，市值一只飙升1一千亿美元 http://36kr.com'" }
    sequence(:hash_title) { |n| "36氪号称全球最牛逼的科技媒体公司今#{n}天上市" }
    news_url "http://36kr.com"
    column
    author

    trait :newsflash_data do
      description_text "根据本报讯，今天上午全球最牛逼的科技媒体公司36氪在拉斯维达斯成功上市，市值一只飙升1一千亿美元"
      tag_list '_newsflash'
    end

    trait :newsflash_data do
      what '陌陌'
      how ''
      think_it_twice ''
      tag_list '_pdnote'
    end
  end
end
