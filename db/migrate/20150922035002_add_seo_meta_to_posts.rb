class AddSeoMetaToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :seo_meta, :text
  end
end
