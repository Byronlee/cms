# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  post_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  paginates_per 20

  belongs_to :post
  belongs_to :user

  validates :post_id, :user_id, presence: true
  validates_uniqueness_of :post_id, scope: :user_id
end
