class RemoveColumnInInfoFlowFromColumns < ActiveRecord::Migration
  def up
    remove_column :columns, :in_info_flow
  end

  def down
    add_column :columns, :in_info_flow, :string
  end
end
