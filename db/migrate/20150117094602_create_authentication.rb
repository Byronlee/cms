class CreateAuthentication < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid
      t.string :provider
      t.text :raw
      t.integer :user_id

      t.timestamps
    end
  end
end
