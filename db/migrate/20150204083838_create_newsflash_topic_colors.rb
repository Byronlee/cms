class CreateNewsflashTopicColors < ActiveRecord::Migration
  def change
    create_table :newsflash_topic_colors do |t|
      t.string :site_name
      t.string :color

      t.timestamps
    end
  end
end
