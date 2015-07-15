class CreateColumnsAndSites < ActiveRecord::Migration
  def change
    create_table :columns_sites do |t|
      t.integer :column_id, index: true
      t.integer :site_id, index: true

      t.timestamps
    end
  end
end
