class AddColumnsMetasInfoToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :title, :string
    add_column :head_lines, :type, :string
    add_column :head_lines, :image, :string
  end
end
