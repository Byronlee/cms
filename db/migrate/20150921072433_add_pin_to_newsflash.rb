class AddPinToNewsflash < ActiveRecord::Migration
  def change
    add_column :newsflashes, :pin, :boolean, default: false
  end
end
