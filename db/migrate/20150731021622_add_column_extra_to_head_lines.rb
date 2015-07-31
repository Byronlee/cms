class AddColumnExtraToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :extra, :text
  end
end
