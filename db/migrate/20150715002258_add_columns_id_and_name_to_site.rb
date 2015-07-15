class AddColumnsIdAndNameToSite < ActiveRecord::Migration
  def change
    add_column :sites, :columns_id_and_name, :string, array: true, default: []
  end
end
