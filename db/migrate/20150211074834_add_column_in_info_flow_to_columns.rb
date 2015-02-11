class AddColumnInInfoFlowToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :in_info_flow, :boolean
  end
end
