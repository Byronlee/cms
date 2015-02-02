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
  validates :content, presence: true
  validates :content, length: { maximum: 3_000 }

  belongs_to :commentable, :polymorphic => true

  before_save :set_is_long_attribute

  private

  def set_is_long_attribute
    self.is_long = self.content.length > 140
    return true
  end
end
