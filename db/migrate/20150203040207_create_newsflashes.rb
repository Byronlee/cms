class CreateNewsflashes < ActiveRecord::Migration
  def change
    create_table :newsflashes do |t|
      t.text :original_input
      t.string :hash_title
      t.text :description_text
      t.string :news_url
      t.integer :newsflash_topic_color_id
      t.string :news_summaries, :array => true, default: []
      t.timestamps
    end
  end
end
