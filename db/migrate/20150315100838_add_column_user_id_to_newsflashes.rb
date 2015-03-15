class AddColumnUserIdToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :user_id, :integer
  end
end
