class ChangeMobileUrlType < ActiveRecord::Migration
  def change
    change_column :mobile_ads, :ad_url, :text
  end
end
