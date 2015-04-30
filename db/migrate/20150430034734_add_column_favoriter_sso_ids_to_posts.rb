class AddColumnFavoriterSsoIdsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :favoriter_sso_ids, :text, array: true, default: []
  end
end
