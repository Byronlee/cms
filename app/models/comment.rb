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
#  state            :string(255)
#

class Comment < ActiveRecord::Base
  include AASM
  aasm.attribute_name :state
  paginates_per 20

  validates :content, presence: true
  validates :content, length: { maximum: 3_000 }

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  before_save :set_is_long_attribute

  # default_scope {order('char_length(content) DESC')}
  default_scope {order('created_at DESC')}
  scope :excellent, -> { where(is_excellent: true, state:[:published, :prepublish]) }
  scope :normal, -> { where(is_excellent: [false, nil], state:[:published, :prepublish]) }

  aasm do
    state :reviewing, :initial => true
    state :published
    state :rejected
    state :prepublish

    event :publish do
      transitions :from => [:reviewing, :rejected, :prepublish], :to => :published
    end

    event :reject do
      transitions :from => [:reviewing, :published, :prepublish], :to => :rejected
    end
  end

  def set_state
    if self.user.may_publish?
      self.state = 'publish'
    elsif self.user.may_prepublish?
      self.state = 'prepublish'
    end
  end
  private

  def set_is_long_attribute
    self.is_long = self.content.length > 140
    return true
  end
end
