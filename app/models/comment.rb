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
#  email            :string(255)
#

require 'action_view'
class Comment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include AASM

  aasm.attribute_name :state
  paginates_per 100
  by_star_field :created_at

  validates :content, presence: true
  validates :content, length: { maximum: 3_000 }
  validates_uniqueness_of :content

  belongs_to :commentable, :polymorphic => true, counter_cache: true
  belongs_to :post, -> { where(comments: { commentable_type: 'Post' }) }, foreign_key: 'commentable_id'
  belongs_to :user

  before_save :set_is_long_attribute

  after_save :update_excellent_comments_cache
  after_destroy :update_excellent_comments_cache

  scope :order_by_content, -> {
    includes(:commentable, user: [:krypton_authentication]).order('char_length(content) desc')
  }

  scope :excellent, -> { includes(:post).where(posts: { state: :published }, is_excellent: true) }

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

  private

  def set_is_long_attribute
    self.is_long = content.length > 140
    true
  end

  def update_excellent_comments_cache
    logger.info 'perform the worker to update excellent comments cache'
    logger.info ExcellentCommentsComponentWorker.new.perform
    true
  end
end
