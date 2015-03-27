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
#  news_summaries           :string(255)      default([]), is an Array
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#

class Newsflash < ActiveRecord::Base
  validates_presence_of :original_input, :hash_title, :description_text

  validates :description_text, length: { maximum: 500 }
  validates :hash_title,       length: { maximum: 40  }

  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'
  belongs_to :newsflash_topic_color

  paginates_per 100
  acts_as_taggable
  by_star_field :created_at

  before_validation :prase_original_input
  after_save :update_new_flash_cache
  after_destroy :update_new_flash_cache

  def prase_original_input
    inputs = original_input.split(/---{0,}/)
    prase_basic_attrs_from_original_input inputs[0].strip
    prase_summaries_from_original_input inputs[1].strip if inputs[1]
  end

  private

  def prase_basic_attrs_from_original_input(input)
    return unless !!(/^#(.+??)#(.+??)$/ =~ input)
    valid_url = URI.extract(input).last
    self.hash_title, self.description_text, self.news_url = $1, $2.gsub(valid_url.to_s, ''), valid_url
  end

  def prase_summaries_from_original_input(input)
    summaries = input.split(/n\d[\.|\．]/).select { |s| !s.blank? }
    self.news_summaries = summaries
  end

  def update_new_flash_cache
    logger.info 'perform the worker to update new flash cache'
    # logger.info NewPostsComponentWorker.perform_async
    logger.info NewPostsComponentWorker.new.perform
    true
  end
end
