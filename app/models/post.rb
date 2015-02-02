# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  summary    :string(255)
#  content    :text
#  title_link :string(255)
#  must_read  :boolean
#  slug       :string(255)
#  state      :string(255)
#  draft_key  :string(255)
#  column_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  cover      :string(255)
#  source_id  :integer
#

class Post < ActiveRecord::Base
  paginates_per 20
  mount_uploader :cover, BaseUploader

  validates :title, :summary, :content, :title_link, presence: true unless new_record?
  validates :slug,    length: { maximum: 14 } unless new_record?
  validates :summary, length: { maximum: 40 } unless new_record?
  validates :title,   length: { maximum: 40 }
  validates :content, length: { maximum: 10_000 }

  belongs_to :column
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
end
