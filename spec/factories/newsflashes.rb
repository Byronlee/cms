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
#  news_summaries           :string(255)      default([]), is an Array
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsflash do
    original_input 'MyText'
  end
end
