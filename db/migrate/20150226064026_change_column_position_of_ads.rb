class ChangeColumnPositionOfAds < ActiveRecord::Migration
  def up
    change_column :ads, :position, 'integer USING CAST(position AS integer)'
  end

  def down
    change_column :ads, :position, :string
  end
end
