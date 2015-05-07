class AddColumnTopToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :is_top, :boolean
    add_column :newsflashes, :toped_at, :timestamp
  end
end
