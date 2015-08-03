# == Schema Information
#
# Table name: head_lines
#
#  id               :integer          not null, primary key
#  url              :string(255)
#  order_num        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  title            :string(255)
#  post_type        :string(255)
#  image            :string(255)
#  user_id          :integer
#  url_code         :integer
#  state            :string(255)
#  section          :string(255)
#  display_position :text
#  summary          :text
#

require 'common'
class HeadLine < ActiveRecord::Base
  include AASM
  aasm.attribute_name :state
  paginates_per 20
  extend Enumerize

  enumerize :display_position, in: [:normal, :next], default: :next

  validates :url, :title, presence: true
  validates_uniqueness_of :url
  validates :url, :url => { allow_blank: true }

  belongs_to :user

  scope :published, -> { where(state: :published) }
  scope :archived, -> { where(state: :archived) }
  scope :normal, -> { where(display_position: [:normal, :nil]) }
  scope :next, -> { where(display_position: :next) }
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

  def self.parse_url(url)
    return { result: false, msg: 'URL不可为空', metas: {} } unless url.present?
    success, msg = valid_of?(url)
    return { result: false, msg: msg, metas: {} } unless success
    og = OpenGraph.new(url.split("#").first)
    metas = {
      title: og.title,
      type: og.type,
      section: get_customer_meta_of(og, :article, :section),
      url: og.url,
      description: og.description,
      image: og.images.first,
      code: get_customer_meta_of(og, :code)
    }
    { result: true, msg:'', metas: metas }
  rescue Exception => ex
    return { result: false, msg: ex.message, metas: {} }
  end

  after_save :update_head_line_cache
  def update_head_line_cache
    HeadLinesComponentWorker.new.perform
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
