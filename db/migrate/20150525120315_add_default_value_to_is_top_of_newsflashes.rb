class AddDefaultValueToIsTopOfNewsflashes < ActiveRecord::Migration
  def change
  	change_column :newsflashes, :is_top, :boolean, :default => false

  	Newsflash.where("is_top is null").update_all(is_top: false)
  end
end
