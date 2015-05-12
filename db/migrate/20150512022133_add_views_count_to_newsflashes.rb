class AddViewsCountToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :views_count, :integer, :default => 0
  end
end
