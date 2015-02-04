class CreateNewsflashes < ActiveRecord::Migration
  def change
    create_table :newsflashes do |t|
      t.text :original_input
      t.string :hash_title
      t.text :description_text
      t.string :news_url

      t.timestamps
    end
  end
end
