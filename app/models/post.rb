# == Schema Information
#
# Table name: posts
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  summary                :text
#  content                :text
#  title_link             :string(255)
#  must_read              :boolean
#  slug                   :string(255)
#  state                  :string(255)
#  draft_key              :string(255)
#  column_id              :integer
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  cover                  :text
#  source                 :string(255)
#  comments_count         :integer
#  md_content             :text
#  url_code               :integer
#  views_count            :integer          default(0)
#  catch_title            :string(255)
#  published_at           :datetime
#  key                    :string(255)
#  remark                 :text
#  extra                  :text
#  source_type            :string(255)
#  favorites_count        :integer
#  company_keywords       :string(255)      default([]), is an Array
#  favoriter_sso_ids      :integer          default([]), is an Array
#  related_post_url_codes :integer          default([]), is an Array
#  seo_meta               :text
#

require 'action_view'
class Post < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers
  include Tire::Model::Search
  include Tire::Model::Callbacks if Settings.elasticsearch.auto_index
  include ApplicationHelper
  include PostsHelper
  extend Enumerize
  include AASM

  by_star_field '"posts".published_at'
  page_view_field :views_count, interval: 1800
  page_view_field :mobile_views_count, interval: 1800
  paginates_per 100

  enumerize :source_type, in: [:original, :translation, :reference, :contribution], default: :original

  typed_store :extra do |s|
    s.text :source_urls, default: ''
    s.datetime :will_publish_at, default: ''
    s.string :jid,  default: ''
    s.boolean :close_comment, default: false
    s.integer :mobile_views_count, default: 0
  end

  # mount_uploader :cover, BaseUploader
  aasm.attribute_name :state

  validates_presence_of :title, :content, :url_code
  validates_uniqueness_of :title, :content, :url_code
  validates_presence_of :published_at, if: -> { self.state == "published" }
  validates :title, :slug, length: { maximum: 250 }
  validates :catch_title, length: { maximum: 18 }

  belongs_to :column, counter_cache: true
  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :favorites, foreign_key: :url_code, primary_key: :url_code, dependent: :destroy
  has_many :favoriters, source: :user, through: :favorites, primary_key: :url_code
  has_many :related_links, dependent: :destroy

  # TODO: 将所有的回调采用注册机制全部异步去处理
  after_save :update_today_lastest_cache, :update_info_flows_cache,
             :check_head_line_cache, :update_excellent_comments_cache, :fetch_related_posts
  after_destroy :update_today_lastest_cache, :update_info_flows_cache,
                :check_head_line_cache_for_destroy, :update_excellent_comments_cache
  before_create :generate_key
  before_save :auto_generate_summary, :check_source_type
  before_validation :generate_url_code
  after_save :check_company_keywords
  def check_company_keywords
    keywords = content.scan(/<u>(.*?)<\/u>/).flatten.select { |c| c.length < 10 }
    self.company_keywords = keywords if keywords.present?
  end

  #after_save :update_kr_search_index
  def update_kr_search_index
    logger.info UpdateElsearchIndexWorker.new.perform self.url_code
  end

  # 是否每次更新都要执行？需要确认
  after_commit :sync_post_seo, on: :create
  def sync_post_seo
    template_id = 'www-article'
    content_sanitize = ActionController::Base.helpers.sanitize(self.content, tags: %w(), attributes: %w())[0..120]
    push_params = { id: self.url_code, content: content_sanitize, title: self.title, keywords: self.tag_list.to_s, description: "#{content_sanitize}...", author: self.author.display_name }
    response = Seo.writer(template_id, push_params)
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      response = Seo.read(template_id, self.url_code)
      data = ActiveSupport::JSON.decode(response.body)
      if response.success? and data['code'] == 0
        redis_hash = Redis::HashKey.new(template_id)
        redis_hash[self.url_code] = data['data']
        logger.info "success: #{redis_hash[self.url_code]}---#{data['data']}"
      else
        logger.error "fail: #{data['data']}"
      end
    else
      logger.error "fail: #{data['data']}"
    end
  end

  def activate_publish_schedule
    return true if self.published?
    return self.publish if self.will_publish_at.blank?
    Sidekiq::Queue.new("krx2015").each do |job|
      job.delete if job.jid == self.jid
    end
    self.jid = PostPublishWorker.perform_at(self.will_publish_at, self.id)
  end

  scope :published_on, -> (date) {
    where(:published_at => date.beginning_of_day..date.end_of_day)
  }
  scope :reviewing, -> { where(:state => :reviewing) }
  scope :published, -> { where(:state => :published) }
  scope :drafted,   -> { where(:state => :drafted) }
  scope :hot_posts, -> { order('id desc, views_count desc') }
  scope :recent,    -> { order('published_at desc') }

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
    params[:page] ||= 1 if paginate_by_id_request?(params) && (boundary_post = Post.find_by_url_code(params[:b_url_code]))
    tire.search(load: true, page: params[:page], per_page: params[:per_page] || 30) do
      highlight :title, options: { tag: "<em class='highlight' >" }
      min_score 1
      query do
        boolean do
          must { string Tire::Utils::escape_query(params[:q].presence) || "*", default_operator: "AND" }
          must { term :state, :published }
          must { range :published_at, { lt: boundary_post.published_at } } if boundary_post && params[:d] == 'next'
          must { range :published_at, { gt: boundary_post.published_at } } if boundary_post && params[:d] == 'pre'
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
      transitions :from => [:reviewing, :drafted], :to => :published
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

  def column_name
    column.try(:name)
  end

  def cover_real_url
    cover
  end

  def heading_cover_url
    "#{cover}!heading"
  end

  def square_cover_url
    "#{cover}!square"
  end

  def comments_counts
    update_attribute(:comments_count, comments.size) if comments_count.nil?
    comments_count
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

  def source_urls_array
    return [] if source_urls.blank?
    source_urls.split
  end

  def record_laster_update_user(current_user, action_path)
   return unless need_record_update_log?(current_user)
    self.remark = self.remark.to_s + "[#{Time.now}]#{current_user.id} - #{current_user.display_name} edited [#{action_path}]\r\n"
  end

  def self.paginate(posts, params)
    params[:per_page] = 15
    if paginate_by_id_request?(params) && (boundary_post = Post.find_by_url_code(params[:b_url_code]))
      posts = Post.paginate_by_url_code(posts, params[:d], boundary_post)
    else
      posts = posts.page(params[:page]).per(params[:per_page] || 15)
    end
  end

  def self.merger_newsflashes(column, posts, params)
    start_time = posts.present? ? posts.last.published_at : Time.parse('2000-01-01')
    if paginate_by_id_request?(params)
      if posts.present?
        end_time = posts.first.published_at
      elsif (boundary_post = Post.find_by_url_code(params[:b_url_code]))
        end_time = boundary_post.published_at
      else
        return posts
      end
    else
      end_time   = Time.now
    end
    newsflashes  = Newsflash.find_newsflashes_by_datetime(column, start_time, end_time)
    result       = posts.to_a + newsflashes.to_a
    result.sort do |a, b|
      get_object_time(b) <=> get_object_time(a)
    end
  end

  def related_posts
    Post.where(:url_code => self.related_post_url_codes).published
  end

  def get_related_post_url_codes
    posts = self.find_related_tags.published.where.not(id: self.id.to_i).limit(3)
    posts = self.author.posts.published.where.not(id: self.id.to_i).recent.limit(3) if posts.blank? && self.author.present?
    posts.map(&:url_code)
  end

  private

  def self.get_object_time(obj)
    obj.is_a?(Post) ? obj.published_at : obj.created_at
  end

  def self.paginate_by_id_request?(params)
    params[:d].present? && params[:b_url_code].present?
  end

  def self.paginate_by_url_code(posts, page_direction, boundary_post)
    if page_direction == 'next' && boundary_post.present?
      posts = posts.where('posts.published_at < ?', boundary_post.published_at)
    elsif page_direction == 'prev' && boundary_post.present?
      posts = posts.where('posts.published_at > ?', boundary_post.published_at)
    end
    posts = posts.page(1).per(15)
  end

  def self.posts_to_json(posts, from_tire = false)
    posts_results = from_tire ? posts.results : posts

    { :total_count => posts.total_count,
      :min_url_code =>  (posts_results.last ? posts_results.last.url_code : nil),
      :max_url_code =>  (posts_results.first ? posts_results.first.url_code : nil),
      :posts => JSON.parse(posts_json_str(posts)) }
  end

  def self.posts_json_str(posts)
    posts.to_json(
      :except => [:content],
      :methods => [:cover_real_url, :comments_counts],
      :include => {
        :author => {
          :only => [], :methods => [:display_name] },
        :column => {
          :only => [:id, :name, :slug] }
        }
      )
  end

  def update_today_lastest_cache
    return true unless watched_columns_changed?(:today_lastest)
    logger.info 'perform the worker to update today lastest cache'
    logger.info TodayLastestComponentWorker.new.perform
    true
  end

  def update_info_flows_cache
    return true unless watched_columns_changed?(:info_flows)
    self.column && self.column.info_flows.map(&:update_info_flows_cache)
    true
  end

  def generate_key
    self.key = SecureRandom.uuid
    true
  end

  def generate_url_code
    self.url_code = Post.maximum('id').to_i + 5_001_000 if self.url_code.blank?
    true
  end

  def check_head_line_cache
    return true unless watched_columns_changed?(:head_line)
    return true if self.published?
    check_head_line_cache_for_destroy
  end

  def check_head_line_cache_for_destroy
    HeadLine.published.each do |head_line|
      next unless head_line.post_type == 'article' && head_line.url_code == url_code
      head_line.archive
      head_line.save
    end
    true
  end

  def update_excellent_comments_cache
    return true unless watched_columns_changed?(:excellent_comments)
    logger.info 'perform the worker to update excellent comments cache'
    logger.info ExcellentCommentsComponentWorker.new.perform
    true
  end

  def auto_generate_summary
    return true if summary.present?
    self.summary = /^(.*?([。|；|!|?|？|！|.]|\z))/imx.match(strip_tags(content))[1] rescue nil
    true
  end

  before_save :autoset_source_info
  def autoset_source_info
    self.source_urls = if source_type == "original"
      nil
    elsif source_urls.present?
      self.source_urls_array.join(" ")
    end
  end

  def need_record_update_log?(current_user)
    return false if new_record? || current_user.blank? || self.user_id == current_user.id
    return watched_columns_changed?(:record_update)
  end

  # TODO: 补充相应测试
  def watched_columns_changed?(observer = nil)
     columns = [:title, :url_code, :title_link, :slug, :state, :published_at, :column_id]

     case observer
     when :info_flows
       columns.concat [:summary, :user_id, :cover]
     when :head_line
       columns.concat [:cover]
     when :record_update
       columns.concat [:summary, :user_id, :cover, :content, :md_content, :draft_key, :source, :source_type]
     when :today_lastest
     when :excellent_comments
     end
     columns.collect {  |col| eval "#{col}_changed?" }.any?
  end

  def check_source_type
    return true unless source_type.contribution?
    return true if user_id == 785
    self.user_id = 785
  end

  def fetch_related_posts
    if(self.related_post_url_codes.blank? || (self.tag_list.present? && self.tag_list_changed?))
      self.update_column(:related_post_url_codes, get_related_post_url_codes)
      logger.info "update post##{self.url_code} related_posts for #{self.tag_list}"
    end
  end
end
