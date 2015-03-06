class RenamePostsOldPostIdToUrlCode < ActiveRecord::Migration
  def change
    rename_column :posts, :old_post_id, :url_code
  end
end
