class AddPostIdToRelatedLinks < ActiveRecord::Migration
  def change
    add_column :related_links, :post_id, :integer
  end
end
