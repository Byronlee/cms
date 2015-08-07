class AddColumnOrderNumToColumnsSites < ActiveRecord::Migration
  def change
    add_column :columns_sites, :order_num, :integer, default: 0
  end
end
