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
#

class Newsflash < ActiveRecord::Base
  validates_presence_of :hash_title

  validates :description_text, length: { maximum: 500 }

  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  belongs_to :newsflash_topic_color
  belongs_to :column

  paginates_per 100
  acts_as_taggable
  by_star_field :created_at
  page_view_field :views_count, interval: 600

  after_save :update_new_flash_cache
  after_destroy :update_new_flash_cache

  scope :recent,     -> { order('created_at desc') }
  scope :top_recent, -> { order('toped_at desc nulls last, created_at desc') }
  validates :news_url, length: { maximum: 254 }

  typed_store :extra do |s|
    s.string :news_url_type, default: '原文链接'
    s.text :what
    s.text :how
    s.text :think_it_twice
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

  def self.find_newsflashes_by_datetime(column, start_time, end_time)
    column.newsflashes.tagged_with('_newsflash').where(created_at: start_time..end_time)
  end

  private

  def update_new_flash_cache
    logger.info 'perform the worker to update new flash cache'
    NewPostsComponentWorker.new.perform
    true
  end
end
