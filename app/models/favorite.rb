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

  belongs_to :post, foreign_key: :url_code, primary_key: :url_code, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :url_code, :user_id, presence: true
  validates_uniqueness_of :url_code, scope: :user_id

  after_create :update_posts_favoriter_sso_ids_for_create
  after_destroy :update_posts_favoriter_sso_ids_for_destroy

  private

  def update_posts_favoriter_sso_ids_for_create
    return true if (sso_id = user.krypton_authentication.try(:uid)).blank?
    post.favoriter_sso_ids << sso_id
    post.update_column(:favoriter_sso_ids, post.favoriter_sso_ids.uniq)
  end

  def update_posts_favoriter_sso_ids_for_destroy
    return true if (sso_id = user.krypton_authentication.try(:uid)).blank?
    post.favoriter_sso_ids.delete(sso_id)
    post.update_column(:favoriter_sso_ids, post.favoriter_sso_ids)
  end

end
