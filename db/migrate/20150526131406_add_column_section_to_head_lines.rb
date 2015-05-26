class AddColumnSectionToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :section, :string
  end
end
