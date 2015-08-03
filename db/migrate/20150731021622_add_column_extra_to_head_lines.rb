class AddColumnExtraToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :display_position, :text
    add_column :head_lines, :summary, :text
    
    HeadLine.update_all display_position: :normal
  end

end
