class AddColumnSectionTextToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :section_text, :string
  end
end
