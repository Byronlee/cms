class AddColumnCommentsExcellentAndLongAttributesToComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_excellent, :boolean
    add_column :comments, :is_long, :boolean
  end
end
