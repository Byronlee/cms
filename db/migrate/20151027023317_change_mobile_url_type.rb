class ChangeMobileUrlType < ActiveRecord::Migration
  def up
    change_column :mobile_ads, :ad_url, :text
  end

  def down
    change_column :mobile_ads, :ad_url, :string
  end
end
