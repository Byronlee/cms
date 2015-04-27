class AddOrderNumToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :order_num, :integer, default: 0
  end
end
