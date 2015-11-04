class AddColumnCatchTitleToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :catch_title, :string
  end
end
