# == Schema Information
#
# Table name: posts
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  summary                :text
#  content                :text
#  title_link             :string(255)
#  must_read              :boolean
#  slug                   :string(255)
#  state                  :string(255)
#  draft_key              :string(255)
#  column_id              :integer
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  cover                  :text
#  source                 :string(255)
#  comments_count         :integer
#  md_content             :text
#  url_code               :integer
#  views_count            :integer          default(0)
#  catch_title            :string(255)
#  published_at           :datetime
#  key                    :string(255)
#  remark                 :text
#  extra                  :text
#  source_type            :string(255)
#  favorites_count        :integer
#  company_keywords       :string(255)      default([]), is an Array
#  favoriter_sso_ids      :integer          default([]), is an Array
#  column_name            :string(255)
#  api_hits_count         :integer          default(0)
#  related_post_url_codes :integer          default([]), is an Array
#

FactoryGirl.define do
  factory :post do
    author
    column
    sequence(:title) { |n| "title#{SecureRandom.uuid}#{n} fuck you" }
    sequence(:slug) { |n| "slug#{n}" }
    summary { "#{title}'s summary" }
    content { "#{title}'s content" }
    sequence(:title_link) { |n| "http://com.google.com/#{n}" }
    source 'writer'
    must_read true
    views_count 0
    source_type 'original'
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

    trait :draft do
      state 'drafted'
    end

    trait :translation do
      source_type 'translation'
      source_urls 'http://36kr.com http://www.google.com'
    end

    factory :post_with_related_links do
      after(:create) do |post, evaluator|
        create_list(:related_link, 5, post: post)
      end
    end
  end
end
