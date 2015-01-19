class RemoveDefaultValueOfBlankStringFromPhontAndEmailOfUsers < ActiveRecord::Migration
  def change
  	#change_column_default(:users, :email, nil)
  	# not work int postgres, because it set the default value to NULL::character varying
  	#, not null

  	change_column_null(:users, :email, true)
  	change_column_null(:users, :phone, true)
  end
end
