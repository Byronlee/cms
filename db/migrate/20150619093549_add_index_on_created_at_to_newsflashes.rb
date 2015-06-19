class AddIndexOnCreatedAtToNewsflashes < ActiveRecord::Migration
  def change
  	add_index :newsflashes, :created_at
  end
end
