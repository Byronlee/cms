# == Schema Information
#
# Table name: newsflashes
#
#  id                       :integer          not null, primary key
#  original_input           :text
#  hash_title               :string(255)
#  description_text         :text
#  news_url                 :string(255)
#  newsflash_topic_color_id :integer
#  news_summaries           :string(8000)
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  cover                    :string(255)
#  is_top                   :boolean          default(FALSE)
#  toped_at                 :datetime
#  views_count              :integer          default(0)
#  column_id                :integer
#  extra                    :text
#  display_in_infoflow      :boolean
#  pin                      :boolean          default(FALSE)
#

class Newsflash < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks if Settings.elasticsearch.auto_index

  validates_presence_of :hash_title

  validates :description_text, length: { maximum: 500 }

  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  belongs_to :newsflash_topic_color
  belongs_to :column

  paginates_per 100
  acts_as_taggable
  by_star_field :created_at
  page_view_field :views_count, interval: 600

  after_save :update_new_flash_cache, :update_info_flows_cache
  after_destroy :update_new_flash_cache, :update_info_flows_cache

  scope :recent,     -> { order('created_at desc') }
  scope :pins,     -> { where(pin: true).order('created_at desc') }
  scope :top_recent, -> { order('toped_at desc nulls last, created_at desc') }
  scope :to_info_flow, -> { where(display_in_infoflow: true) }
  scope :newsflashes, -> { tagged_with('_newsflash') }
  scope :product_notes, -> { tagged_with('_pdnote') }
  validates :news_url, length: { maximum: 254 }

  mapping do
    indexes :id,             index:    :not_analyzed
    indexes :hash_title,     analyzer: 'snowball',   boost:    100
    indexes :taging,         type:     'string'
    indexes :created_at,     type:     'date'
    indexes :updated_at,     type:     'date'
  end

  typed_store :extra do |s|
    s.string :news_url_type, default: '原文链接'
    s.text :what
    s.text :how
    s.text :think_it_twice
  end

  def self.search(params)
    params[:page] ||= 1 if params[:d].present? && params[:b_id].present? && (boundary_newsfalsh = Newsflash.find_by_id(params[:b_id]))
    tire.search(load: true, page: params[:page] || 1, per_page: params[:per_page] || 30) do
      highlight :hash_title, options: { tag: "<em class='highlight' >" }
      min_score 1
      query do
        boolean do
          must { string Tire::Utils::escape_query(params[:q].presence) || "*", default_operator: "AND" }
          must { term :_type, :newsflash }
          must { range :created_at, { lt: boundary_newsfalsh.created_at } } if boundary_newsfalsh && params[:d] == 'next'
          must { range :created_at, { gt: boundary_newsfalsh.created_at } } if boundary_newsfalsh && params[:d] == 'pre'
        end
      end
      sort do
        by :created_at, :desc
        by :_score, :desc
      end
    end
  end

  def set_top
    Newsflash.transaction do
      self.is_top = true
      self.toped_at = Time.now
    end
  end

  def set_down
    Newsflash.transaction do
      self.is_top = false
      self.toped_at = nil
    end
  end

  def fast_type
    tag_list.include?('_newsflash') ? 'newsflash' : 'pdnote'
  end

  def taging
    self.tagged_with '_newsflash'
  end

  def self.find_newsflashes_by_datetime(column, start_time, end_time)
    column.newsflashes.tagged_with('_newsflash').where(created_at: start_time..end_time)
  end

  def self.paginate(newsflashes, params)
    b_newsflash = Newsflash.find(params[:b_id]) if params[:b_id]
    if b_newsflash && params[:d] == 'next'
      newsflashes = newsflashes.where('newsflashes.created_at < ?', b_newsflash.created_at).recent.page(1).per(params[:per_page] || 30)
    elsif b_newsflash && params[:d] == 'prev'
      newsflashes = newsflashes.where('newsflashes.created_at > ?', b_newsflash.created_at).order(created_at: :desc).last(30)
    end
    [newsflashes, b_newsflash]
  end

  private

  def update_new_flash_cache
    logger.info 'perform the worker to update new flash cache'
    NewPostsComponentWorker.new.perform
    true
  end

  def update_info_flows_cache
    return true unless [:hash_title, :description_text, :news_url, :news_url_type, :user_id, :column_id, :display_in_infoflow, :cover].collect {  |col| eval "#{col}_changed?" }.any?
    self.column && self.column.info_flows.map(&:update_info_flows_cache)
    true
  end
end
