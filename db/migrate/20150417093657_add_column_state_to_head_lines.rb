class AddColumnStateToHeadLines < ActiveRecord::Migration
  def change
    add_column :head_lines, :state, :string

    HeadLine.all.each do |head_line|
      head_line.update_column(:state, 'published')
    end
  end
end
