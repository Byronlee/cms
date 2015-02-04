# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  is_excellent     :boolean
#  is_long          :boolean
#

class Comment < ActiveRecord::Base
  paginates_per 20

  validates :content, presence: true
  validates :content, length: { maximum: 3_000 }

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  before_save :set_is_long_attribute

  # default_scope {order('char_length(content) DESC')}
  default_scope {order('created_at DESC')}
  scope :excellent, -> { where(is_excellent: true) }
  scope :normal, -> { where(is_excellent: [false, nil]) }

  private

  def set_is_long_attribute
    self.is_long = self.content.length > 140
    return true
  end
end
