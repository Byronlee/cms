class AddUserIdToRelatedLinks < ActiveRecord::Migration
  def change
    add_column :related_links, :user_id, :integer
  end
end
