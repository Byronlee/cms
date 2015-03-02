class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :position
      t.text :content

      t.timestamps
    end
  end
end
