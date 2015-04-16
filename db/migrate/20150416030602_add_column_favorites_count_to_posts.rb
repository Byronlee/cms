class AddColumnFavoritesCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :favorites_count, :integer
  end
end
