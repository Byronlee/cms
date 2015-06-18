class AddColumnHiddenCoverToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :hidden_cover, :boolean, default: false
  end
end
