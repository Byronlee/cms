class AddColumnUserIdToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :user_id, :integer
  end
end
