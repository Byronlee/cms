class AddRemarkToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :remark, :text
  end
end
