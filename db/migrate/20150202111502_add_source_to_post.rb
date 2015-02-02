class AddSourceToPost < ActiveRecord::Migration
  def change
    add_column :posts, :source, :string, defalut: 'writer'
  end
end
