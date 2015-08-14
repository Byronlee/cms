class AddColumnRelatedPostUrlCodesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :related_post_url_codes, :integer, array: true, default: []
  end
end