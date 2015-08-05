class AddExtraToNewsflash < ActiveRecord::Migration
  def change
    add_column :newsflashes, :extra, :text
  end
end
