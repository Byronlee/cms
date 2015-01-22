class CreateHeadlines < ActiveRecord::Migration
  def change
    create_table :headlines do |t|
      t.string :url
      t.integer :order_num

      t.timestamps
    end
  end
end
