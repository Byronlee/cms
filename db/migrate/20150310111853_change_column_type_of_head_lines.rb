class ChangeColumnTypeOfHeadLines < ActiveRecord::Migration
  def change
    rename_column :head_lines, :type, :post_type
  end
end
