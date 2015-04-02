class AddExtraToPost < ActiveRecord::Migration
  def change
    add_column :posts, :extra, :text
  end
end
