class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :summary
      t.text   :content
      t.string :title_link
      t.boolean :must_read
      t.string :slug
      t.string :state
      t.string :draft_key

      t.timestamps
    end
  end
end
