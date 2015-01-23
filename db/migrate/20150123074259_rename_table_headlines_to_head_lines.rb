class RenameTableHeadlinesToHeadLines < ActiveRecord::Migration
  def change
  	rename_table :headlines, :head_lines
  end
end
