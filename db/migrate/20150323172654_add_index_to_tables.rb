class AddIndexToTables < ActiveRecord::Migration
  def change
     add_index :posts, :url_code, unique: true
     add_index :posts, :key
     add_index :posts, :column_id
     add_index :posts, :user_id
     add_index :posts, :created_at

     add_index :comments, [:commentable_id, :commentable_type]
     add_index :comments, :user_id


     add_index :users, :sso_id
  end
end
