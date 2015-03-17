class AddOrderNumToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :order_num, :string, default: '0'
  end
end
