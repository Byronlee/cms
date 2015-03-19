class AddColumnUrlCodeToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :url_code, :integer
  end
end
