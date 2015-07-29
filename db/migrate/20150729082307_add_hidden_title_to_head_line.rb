class AddHiddenTitleToHeadLine < ActiveRecord::Migration
  def change
    add_column :head_lines, :hidden_title, :boolean
  end
end
