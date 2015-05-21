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
#  is_top                   :boolean
#  toped_at                 :datetime
#  views_count              :integer          default(0)
#

class Newsflash < ActiveRecord::Base
  validates_presence_of :original_input, :hash_title

  validates :description_text, length: { maximum: 500 }

  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  belongs_to :newsflash_topic_color

  paginates_per 100
  acts_as_taggable
  by_star_field :created_at
  page_view_field :views_count, interval: 600

  before_validation :prase_original_input
  after_save :update_new_flash_cache
  after_destroy :update_new_flash_cache

  def prase_original_input
    inputs = original_input.split(/---{0,}/)
    prase_basic_attrs_from_original_input inputs[0].strip
    self.news_summaries = inputs[1].strip if inputs[1]
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

  private

  def prase_basic_attrs_from_original_input(input)
    return unless !!(/^#(.+??)#(.+??)$/ =~ input)
    valid_url = URI.extract(input).last
    self.hash_title, self.description_text, self.news_url = $1, $2.gsub(valid_url.to_s, ''), valid_url
  end

  def update_new_flash_cache
    logger.info 'perform the worker to update new flash cache'
    logger.info NewPostsComponentWorker.new.perform
    true
  end
end
