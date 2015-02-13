class CreateColumnsInfoFlows < ActiveRecord::Migration
  def change
    create_table :columns_info_flows do |t|
      t.integer :info_flow_id
      t.integer :column_id

      t.timestamps
    end
  end
end
