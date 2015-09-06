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
#  ancestry         :string(255)
#

require 'action_view'
class Comment < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include AASM

  has_ancestry
  aasm.attribute_name :state
  paginates_per 100
  by_star_field :created_at

  validates :content, :user_id, presence: true
  validates :content, length: { maximum: 3_000 }

  belongs_to :commentable, :polymorphic => true, counter_cache: true
  belongs_to :post, -> { where(comments: { commentable_type: 'Post' }) }, foreign_key: 'commentable_id'
  belongs_to :user

  before_save :set_is_long_attribute

  STATE_OPTIONS = {reviewing: '审查中', published: '已发布', rejected: '已屏蔽'}

  # after_save :update_excellent_comments_cache
  # after_destroy :update_excellent_comments_cache

  scope :order_by_content, -> {
    includes(:commentable, user: [:krypton_authentication]).order('char_length(content) desc')
  }
  scope :excellent, -> { includes(:post).where(posts: { state: :published }, is_excellent: true) }
  scope :valid_comments, -> (user) { where("state = 'published' or user_id = ? ", user.id) }

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

    event :undo_publish do
      transitions :from => [:published, :rejected, :prepublished], :to => :reviewing
    end
  end

  private

  def set_is_long_attribute
    self.is_long = content.length > 140
    true
  end

  # def update_excellent_comments_cache
  #   logger.info 'perform the worker to update excellent comments cache'
  #   logger.info ExcellentCommentsComponentWorker.new.perform
  #   true
  # end
end
