# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  url_code   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  paginates_per 20

  belongs_to :post, foreign_key: :url_code, primary_key: :url_code
  belongs_to :user

  validates :url_code, :user_id, presence: true
  validates_uniqueness_of :url_code, scope: :user_id
end
