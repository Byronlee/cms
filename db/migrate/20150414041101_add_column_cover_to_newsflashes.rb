class AddColumnCoverToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :cover, :string
  end
end
