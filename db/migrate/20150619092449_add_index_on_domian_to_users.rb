class AddIndexOnDomianToUsers < ActiveRecord::Migration
  def change
  	add_index :users, :domain, using: :hash
  end
end
