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
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include ApplicationHelper
  include PostsHelper
  include AASM

  by_star_field '"posts".published_at'
  page_view_field :views_count
  paginates_per 100
  aasm.attribute_name :state

  validates_presence_of :title, :content
  validates_uniqueness_of :title, :content, :url_code
  validates_presence_of :published_at, if: -> { self.state == "published" }
  # validates_presence_of :summary, :slug, if: -> { persisted? }

  # validates :slug,    length: { maximum: 14 }
  # validates :summary, length: { maximum: 40 }
  # validates :title,   length: { maximum: 40 }
  # validates :content, length: { maximum: 10_000 }

  belongs_to :column, counter_cache: true
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  has_many :comments, as: :commentable, dependent: :destroy
  # has_and_belongs_to_many :favoriters, primary_key: :url_code, class_name: User.to_s, join_table: 'favorites', foreign_key: :url_code
  has_many :favorites, foreign_key: :url_code, primary_key: :url_code
  has_many :favoriters, source: :user, through: :favorites, primary_key: :url_code

  after_save :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache,
             :check_head_line_cache, :update_excellent_comments_cache
  after_destroy :update_today_lastest_cache, :update_hot_posts_cache, :update_info_flows_cache,
                :check_head_line_cache_for_destroy, :update_excellent_comments_cache
  before_create :generate_key
  before_save :auto_generate_summary
  after_create :generate_url_code

  scope :published_on, -> (date) {
    where(:published_at => date.beginning_of_day..date.end_of_day)
  }
  scope :reviewing, ->{ where(:state => :reviewing)}
  scope :published, ->{ where(:state => :published)}
  scope :hot_posts, -> { order('id desc, views_count desc') }
  scope :order_by_ids, ->(ids){
    order_by = ["case"]
    ids.each_with_index.map do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "end"
    order(order_by.join(" "))
  }

  acts_as_taggable

  mapping do
     indexes :id,             index:    :not_analyzed

     indexes :title,          analyzer: 'snowball',   boost:    100
     # indexes :summary,        analyzer: 'snowball',   boost:    50
     # indexes :content,        analyzer: 'snowball',   boost:    30

     indexes :state,          type:     'string',     analyzer: 'keyword'
     indexes :published_at,   type:     'date'
     indexes :created_at,     type:     'date'
     indexes :updated_at,     type:     'date'
  end

  def self.search(params)
    tire.search(load: true, page: params[:page], per_page: 30) do
      min_score 1
      query do
        boolean do
          must {
            string params[:q].presence || "*", default_operator: "AND"
          }
          must {
            term :state, :published
          }
        end
      end
      sort {
        by :published_at, :desc
        by :_score, :desc
      }
    end
  end

  aasm do
    state :reviewing, :initial => true
    state :published

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

  def column_name
    column.name
  end

  def sanitize_content
    sanitize_tags(content)
  end

  def bdnews?
    tag_list.include? 'bdnews'
  end

  def self.today_lastest
    posts_data = Redis::HashKey.new('posts')['today_lastest']
    if posts_data.present?
      hash_data = JSON.parse(posts_data)[0]
      posts = hash_data["posts"]
      posts_count = hash_data["posts_count"]
    else
      posts = []
      posts_count = 0
    end
    { count: posts_count, posts: posts }
  end

  def self.today
    published_on(Date.today)
  end


  def self.find_and_order_by_ids(search)
    ids = search.map(&:id)
    self.where(id: ids).order_by_ids(ids).includes(:column, author:[:krypton_authentication])
  end

  private

  def update_today_lastest_cache
    return true if self.views_count_changed?
    logger.info 'perform the worker to update today lastest cache'
    # logger.info TodayLastestComponentWorker.perform_async
    logger.info TodayLastestComponentWorker.new.perform
    true
  end

  def update_hot_posts_cache
    logger.info 'perform the worker to update hot posts cache'
    # logger.info HotPostsComponentWorker.perform_async
    logger.info HotPostsComponentWorker.new.perform
    true
  end

  # def update_new_posts_cache
  #   logger.info 'perform the worker to update new posts cache'
  #   # logger.info NewPostsComponentWorker.perform_async
  #   logger.info NewPostsComponentWorker.new.perform
  #   true
  # end

  def update_info_flows_cache
    return true if self.views_count_changed?
    self.column && self.column.info_flows.each do |info_flow|
      info_flow.update_info_flows_cache
    end
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
    HeadLine.all.each do |head_line|
      next if head_line.url_code != url_code
      head_line.destroy
    end
    true
  end

   def check_head_line_cache_for_destroy
    HeadLine.all.each do |head_line|
      next if head_line.url_code != url_code
      head_line.destroy
    end
    true
  end

   def update_excellent_comments_cache
    return true if self.views_count_changed?
    logger.info 'perform the worker to update excellent comments cache'
    # logger.info ExcellentCommentsComponentWorker.perform_async
    logger.info ExcellentCommentsComponentWorker.new.perform
    true
  end

  def auto_generate_summary
    return true if summary.present?
    self.summary = /^(.*?[。|；|!|?|？|！|.])/imx.match(strip_tags(content))[1] rescue true
    true
  end
end
