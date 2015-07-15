class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name, index: true
      t.text :description
      t.string :domain
      t.integer :info_flow_id
      t.integer :admin_id

      t.timestamps
    end
  end
end
