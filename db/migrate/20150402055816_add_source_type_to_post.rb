class AddSourceTypeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :source_type, :string
  end
end
