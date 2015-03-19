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
#  cover          :text
#  source         :string(255)
#  comments_count :integer
#  md_content     :text
#  url_code       :integer
#  views_count    :integer          default(0)
#  catch_title    :text
#  published_at   :datetime
#  key            :string(255)
#  remark         :text
#

require 'action_view'
class Post < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  include AASM

  by_star_field '"posts".created_at'
  paginates_per 20
  mount_uploader :cover, BaseUploader
  aasm.attribute_name :state

  # validates_presence_of :title, :content
  # validates_presence_of :summary, :slug, if: -> { persisted? }

  # validates :slug,    length: { maximum: 14 }
  # validates :summary, length: { maximum: 40 }
  # validates :title,   length: { maximum: 40 }
  # validates :content, length: { maximum: 10_000 }

  belongs_to :column, counter_cache: true
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  has_many :comments, as: :commentable, dependent: :destroy

  after_save :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache, :update_new_posts_cache
  after_destroy :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache, :update_new_posts_cache
  before_create :generate_key
  after_create :generate_url_code

  scope :created_on, ->(date) {
    where(:created_at => date.beginning_of_day..date.end_of_day)
  }
  scope :reviewing, ->{ where(:state => :reviewing)}
  scope :published, ->{ where(:state => :published)}
  scope :hot_posts, -> { order('views_count desc, created_at desc') }

  acts_as_taggable

  aasm do
    state :reviewing, :initial => true
    state :published

    event :publish do
      transitions :from => [:reviewing], :to => :published
    end

    event :undo_publish do
      transitions :from => [:published], :to => :reviewing
    end
  end

  def self.today
    created_on(Date.today)
  end

  def get_access_url
    post_url(self)
  end

  def cover_real_url
    return nil if cover_identifier.nil?
    cover_identifier.include?('http://') ? cover_identifier : cover_url
  end

  def comments_counts
    update_attribute(:comments_count, comments.size) if comments_count.nil?
    comments_count
  end

  private

  def update_today_lastest_cache
    return if self.views_count_changed?
    logger.info 'perform the worker to update today lastest cache'
    logger.info TodayLastestComponentWorker.perform_async
  end

  def update_hot_posts_cache
    logger.info 'perform the worker to update hot posts cache'
    logger.info HotPostsComponentWorker.perform_async
  end

  def update_new_posts_cache
    logger.info 'perform the worker to update new posts cache'
    logger.info NewPostsComponentWorker.perform_async
  end

  # def update_weekly_hot
  #   logger.info 'perform the worker to update weekly newest cache'
  #   logger.info WeeklyHotPostsComponentWorker.perform_async(column_id)
  # end

  def update_info_flows_cache
    self.column && self.column.info_flows.each do |info_flow|
      info_flow.update_info_flows_cache
    end
  end

  def generate_key
    self.key = SecureRandom.uuid
  end

  def generate_url_code
    self.update(url_code: self.id) if self.url_code.blank?
  end
end
