class AddMutedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :muted_at, :datetime
  end
end
