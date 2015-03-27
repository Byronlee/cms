class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :url_code

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :url_code
  end
end
