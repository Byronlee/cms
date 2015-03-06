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
#  cover          :string(255)
#  source         :string(255)
#  comments_count :integer
#  md_content     :text
#  url_code       :integer
#  views_count    :integer          default(0)
#

require 'action_view'
class Post < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  paginates_per 20
  mount_uploader :cover, BaseUploader

  validates_presence_of :title, :content
  validates_presence_of :summary, :title_link, :slug, if: -> { persisted? }

  validates :slug,    length: { maximum: 14 }
  validates :summary, length: { maximum: 40 }
  validates :title,   length: { maximum: 40 }
  validates :content, length: { maximum: 10_000 }

  belongs_to :column, counter_cache: true
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  has_many :comments, as: :commentable, dependent: :destroy

  after_save :update_today_lastest_cache, :update_hot_posts_cache
  after_destroy :update_today_lastest_cache, :update_hot_posts_cache

  scope :created_on, ->(date) {
    where(:created_at => date.beginning_of_day..date.end_of_day)
  }
  scope :hot_posts, -> { order("views_count desc, created_at desc") }

  def self.today
    self.created_on(Date.today)
  end

  def human_created_at
    distance_of_time_in_words_to_now(self.created_at)
  end

  private

  def update_today_lastest_cache
    if !self.views_count_changed?
      logger.info "perform the worker to update today lastest cache"
      logger.info TodayLastestComponentWorker.perform_async
    end
  end

  def update_hot_posts_cache
    if self.views_count_changed?
      logger.info "perform the worker to update hot posts cache"
      logger.info HotPostsComponentWorker.perform_async
    end
  end

end
