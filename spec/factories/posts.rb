# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  summary        :text
#  content        :text
#  title_link     :string(255)
#  must_read      :boolean
#  slug           :string(255)
#  state          :string(255)
#  draft_key      :string(255)
#  column_id      :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  cover          :text
#  source         :string(255)
#  comments_count :integer
#  md_content     :text
#  url_code       :integer
#  views_count    :integer          default(0)
#  catch_title    :text
#  published_at   :datetime
#  key            :string(255)
#  remark         :text
#

FactoryGirl.define do
  factory :post do
    author
    column
    title 'title'
    summary 'summary'
    content 'content'
    title_link 'title_link'
    must_read 'true'
    state 'draft'
    source 'writer'
    views_count 0
  end
end
