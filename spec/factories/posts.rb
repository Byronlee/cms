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
#  cover          :string(255)
#  source         :string(255)
#  comments_count :integer
#  md_content     :text
#  old_post_id    :integer
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
  end
end
