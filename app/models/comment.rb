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

  belongs_to :commentable, :polymorphic => true, counter_cache: true
  belongs_to :user

  before_save :set_is_long_attribute

  scope :order_by_content, -> {
    includes(:commentable, user:[:krypton_authentication])
    .order('char_length(content) desc')
  }
  scope :excellent, -> { where(is_excellent: true, state:[:published, :prepublished]) }
  scope :normal, -> {
    where(is_excellent: [false, nil], state:[:published, :prepublished])
  }
  scope :normal_selfown, ->(user_id) { where(user_id:user_id)}

  aasm do
    state :reviewing, :initial => true
    state :published
    state :rejected
    state :prepublished

    event :publish do
      transitions :from => [:reviewing, :rejected, :prepublished], :to => :published
    end

    event :reject do
      transitions :from => [:reviewing, :published, :prepublished], :to => :rejected
    end
  end

  def set_state
    if self.user.may_publish?
      self.state = 'published'
    elsif self.user.may_prepublish?
      self.state = 'prepublished'
    end
  end

  def may_display?
    [:published, :prepublished].include? self.state.to_sym
  end

  private

  def set_is_long_attribute
    self.is_long = self.content.length > 140
    return true
  end
end
