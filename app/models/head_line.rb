# == Schema Information
#
# Table name: head_lines
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  order_num  :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  post_type  :string(255)
#  image      :string(255)
#  user_id    :integer
#  url_code   :integer
#  state      :string(255)
#

class HeadLine < ActiveRecord::Base
  include AASM
  aasm.attribute_name :state
  paginates_per 20

  validates :url, presence: true
  validates_uniqueness_of :url
  validates :url, :url => { allow_blank: true }

  belongs_to :user

  scope :published, -> { where(state: :published) }
  scope :archived, -> { where(state: :archived) }
  scope :recent, -> { order(updated_at: :desc) }
  scope :weight, -> { order('order_num desc nulls last') }
  scope :related, -> { includes(user: :krypton_authentication)}

  aasm do
    state :published, :initial => true
    state :archived

    event :publish do
      transitions from: [:archived], to: :published
    end

    event :archive do
      transitions from: [:published], to: :archived
    end
  end

  before_save :fetch_remote_metas, if: -> { title.blank? }
  def fetch_remote_metas
    logger.info 'perform the worker to fetch remote metas'
    logger.info HeadLinesComponentWorker.new.perform(self)
    true
  end

  # TODO: 这是只为API提供使用，应该重构删除
  def replies_count
    0
  end

  # TODO: 这是只为API提供使用，应该重构删除
  def excerpt
    title
  end
end
