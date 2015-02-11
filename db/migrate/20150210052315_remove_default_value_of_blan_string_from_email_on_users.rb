class RemoveDefaultValueOfBlanStringFromEmailOnUsers < ActiveRecord::Migration
   def self.up
    change_column :users, :email, :string , :null => true, :default => nil
  end

  def self.down
  end
end
