# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  summary         :text
#  content         :text
#  title_link      :string(255)
#  must_read       :boolean
#  slug            :string(255)
#  state           :string(255)
#  draft_key       :string(255)
#  column_id       :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  cover           :text
#  source          :string(255)
#  comments_count  :integer
#  md_content      :text
#  url_code        :integer
#  views_count     :integer          default(0)
#  catch_title     :text
#  published_at    :datetime
#  key             :string(255)
#  remark          :text
#  extra           :text
#  source_type     :string(255)
#  favorites_count :integer
#

FactoryGirl.define do
  factory :post do
    author
    column
    sequence(:title) { |n| "title#{SecureRandom.uuid}#{n} fuck you" }
    summary 'summary'
    sequence(:content) { |n| "title#{n}#{SecureRandom.uuid} fuck you" }
    title_link 'title_link'
    source 'writer'
    must_read true
    views_count 0
    url_code { |n| n }

    trait :published do
      state 'published'
      published_at 1.hour.ago
    end

    trait :drafted do
      state 'drafted'
      published_at nil
    end

    trait :reviewing do
      state 'reviewing'
    end
  end
end
