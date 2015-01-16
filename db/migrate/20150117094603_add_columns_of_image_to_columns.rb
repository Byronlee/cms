class AddColumnsOfImageToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :cover, :string
    add_column :columns, :icon, :string
  end
end
