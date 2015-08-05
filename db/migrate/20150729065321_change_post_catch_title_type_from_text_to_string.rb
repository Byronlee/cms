class ChangePostCatchTitleTypeFromTextToString < ActiveRecord::Migration
  def change
    change_column :posts, :catch_title, :string
  end
end
