class AddMdContentAndOldPostIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :md_content, :text
    add_column :posts, :old_post_id, :integer
  end
end
