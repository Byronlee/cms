class AddCatchTitleToPost < ActiveRecord::Migration
  def change
    add_column :posts, :catch_title, :text
    reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :tagline, :text }
        dir.down { t.change :tagline, :string }
      end
    end
  end
end
