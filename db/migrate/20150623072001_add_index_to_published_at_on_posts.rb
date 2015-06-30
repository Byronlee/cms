class AddIndexToPublishedAtOnPosts < ActiveRecord::Migration
  def change
  	add_index :posts, :published_at
  end
end
