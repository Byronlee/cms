class CreateInfoFlows < ActiveRecord::Migration
  def change
    create_table :info_flows do |t|
      t.string :name

      t.timestamps
    end
  end
end
