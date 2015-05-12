class CreateRelatedLinks < ActiveRecord::Migration
  def change
    create_table :related_links do |t|
      t.string :url
      t.string :link_type
      t.string :title
      t.string :image
      t.text :description
      t.text :extra

      t.timestamps
    end
  end
end
