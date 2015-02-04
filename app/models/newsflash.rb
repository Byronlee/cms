# == Schema Information
#
# Table name: newsflashes
#
#  id               :integer          not null, primary key
#  original_input   :text
#  hash_title       :string(255)
#  description_text :text
#  news_url         :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Newsflash < ActiveRecord::Base
  paginates_per 20
  validates_presence_of :original_input, :hash_title, :description_text

  validates :description_text, length: { maximum: 140 }
  validates :hash_title,       length: { maximum: 20  }

  belongs_to :author, class_name: User.to_s, foreign_key: 'user_id'

  before_validation :prase_original_input
  def prase_original_input
    return unless /^#(.+??)#(.+??)$/ =~ original_input
    self.hash_title, self.description_text = $1, $2
  end

end
