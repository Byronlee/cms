class AddColumnExtraToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :extra, :text
  end
end
