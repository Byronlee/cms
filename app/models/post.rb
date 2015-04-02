# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  summary         :text
#  content         :text
#  title_link      :string(255)
#  must_read       :boolean
#  slug            :string(255)
#  state           :string(255)
#  draft_key       :string(255)
#  column_id       :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  cover           :text
#  source          :string(255)
#  comments_count  :integer
#  md_content      :text
#  url_code        :integer
#  views_count     :integer          default(0)
#  catch_title     :text
#  published_at    :datetime
#  key             :string(255)
#  remark          :text
#  favorites_count :integer
#

require 'action_view'
class Post < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include ApplicationHelper
  include PostsHelper
  extend Enumerize
  include AASM

  by_star_field '"posts".published_at'
  page_view_field :views_count, interval: 600
  paginates_per 100

  enumerize :source_type, in: [:original, :translation, :reference], default: :original

  typed_store :extra do |s|
    s.text :source_urls, default: ""
  end

  # mount_uploader :cover, BaseUploader
  aasm.attribute_name :state

  validates_presence_of :title, :content
  validates_uniqueness_of :title, :content, :url_code
  validates_presence_of :published_at, if: -> { self.state == "published" }

  belongs_to :column, counter_cache: true
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :favorites, foreign_key: :url_code, primary_key: :url_code, dependent: :destroy
  has_many :favoriters, source: :user, through: :favorites, primary_key: :url_code

  after_save :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache,
             :check_head_line_cache, :update_excellent_comments_cache
  after_destroy :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache,
                :check_head_line_cache_for_destroy, :update_excellent_comments_cache
  before_create :generate_key
  before_save :auto_generate_summary, :record_laster_update_user
  after_create :generate_url_code

  scope :published_on, -> (date) {
    where(:published_at => date.beginning_of_day..date.end_of_day)
  }
  scope :reviewing, -> { where(:state => :reviewing) }
  scope :published, -> { where(:state => :published) }
  scope :drafted,   -> { where(:state => :drafted) }
  scope :hot_posts, -> { order('id desc, views_count desc') }

  acts_as_taggable

  mapping do
    indexes :id,             index:    :not_analyzed
    indexes :title,          analyzer: 'snowball',   boost:    100
    indexes :state,          type:     'string',     analyzer: 'keyword'
    indexes :published_at,   type:     'date'
    indexes :created_at,     type:     'date'
    indexes :updated_at,     type:     'date'
  end

  def self.search(params)
    tire.search(load: true, page: params[:page], per_page: params[:per_page] || 30) do
      min_score 1
      query do
        boolean do
          must { string params[:q].presence || "*", default_operator: "AND" }
          must { term :state, :published }
        end
      end
      sort do
        by :published_at, :desc
        by :_score, :desc
      end
    end
  end

  aasm do
    state :drafted, :initial => true
    state :reviewing
    state :published

    event :review do
      transitions :from => [:drafted], :to => :reviewing
    end

    event :undo_review do
      transitions :from => [:reviewing], :to => :drafted
    end

    event :publish do
      transitions :from => [:reviewing], :to => :published
      after do
        self.published_at = Time.now
      end
    end

    event :undo_publish do
      transitions :from => [:published], :to => :reviewing
    end
  end

  # TODO: 这是只为API提供使用，应该重构删除
  def get_access_url
    post_url(self)
  end

  def cover_real_url
    cover
  end

  def comments_counts
    update_attribute(:comments_count, comments.size) if comments_count.nil?
    comments_count
  end

  # TODO: 这是只为API提供使用，应该重构删除
  def column_name
    column.name
  end

  def sanitize_content
    sanitize_tags(content)
  end

  def bdnews?
    tags.map(&:name).include? 'bdnews'
  end

  def self.today
    published_on(Date.today)
  end

  private

  def update_today_lastest_cache
    return true if self.views_count_changed?
    logger.info 'perform the worker to update today lastest cache'
    logger.info TodayLastestComponentWorker.new.perform
    true
  end

  def update_hot_posts_cache
    logger.info 'perform the worker to update hot posts cache'
    logger.info HotPostsComponentWorker.new.perform
    true
  end

  def update_info_flows_cache
    return true if self.views_count_changed?
    self.column && self.column.info_flows.map(&:update_info_flows_cache)
    true
  end

  def generate_key
    self.key = SecureRandom.uuid
    true
  end

  def generate_url_code
    self.update(url_code: (self.id + 500_000)) if self.url_code.blank?
  end

  def check_head_line_cache
    return true if self.views_count_changed?
    return true if self.published?
    check_head_line_cache_for_destroy
  end

  def source_urls_array
    return [] if source_urls.blank?
    source_urls.split
  end

   def check_head_line_cache_for_destroy
    HeadLine.all.each do |head_line|
      next if head_line.url_code != url_code
      head_line.destroy
    end
    true
  end

  def update_excellent_comments_cache
    return true if views_count_changed?
    logger.info 'perform the worker to update excellent comments cache'
    logger.info ExcellentCommentsComponentWorker.new.perform
    true
  end

  def auto_generate_summary
    return true if summary.present?
    self.summary = /^(.*?[。|；|!|?|？|！|.])/imx.match(strip_tags(content))[1] rescue true
    true
  end

  # TODO: 监听字段来源于配置
  # TODO: 记录字段变更记录应该独立相关的服务，或者使用观察者模式来处理
  def record_laster_update_user
    return true if new_record? || User.current.blank?
    return true unless title_changed? || summary_changed? || content_changed? ||
                       title_link_changed? || slug_changed? || state_changed? ||
                       draft_key_changed? || column_id_changed? || user_id_changed? ||
                       cover_changed? || source_changed? || md_content_changed? ||
                       url_code_changed?
    return true if self.user_id == User.current.id

    if self.remark.present?
      self.remark += "\r\n"
    else
      self.remark = ''
    end
    self.remark += "[#{Time.now}]#{User.current.id} - #{User.current.display_name} edited"
  end

  before_save :autoset_source_info
  def autoset_source_info
    self.source_urls = if source_type == "original"
      nil
    elsif source_urls.present?
      self.source_urls = self.source_urls.split.map(&:strip).join(", ")
    end
  end
end
