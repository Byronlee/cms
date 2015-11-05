class AddColumnRongOrganizationToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :rong_organization_id, :integer
  	add_column :users, :rong_organization_name, :string
  end
end
