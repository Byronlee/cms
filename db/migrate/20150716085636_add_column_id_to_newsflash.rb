class AddColumnIdToNewsflash < ActiveRecord::Migration
  def change
    add_column :newsflashes, :column_id, :integer
  end
end
