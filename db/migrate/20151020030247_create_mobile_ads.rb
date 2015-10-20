class CreateMobileAds < ActiveRecord::Migration
  def change
    create_table :mobile_ads do |t|
      t.string :ad_title
      t.string :ad_url
      t.string :ad_img_url
      t.string :ad_position
      t.datetime :ad_enable_time
      t.datetime :ad_end_time
      t.integer :api_count
      t.integer :click_count
      t.text :ad_summary

      t.timestamps
    end
  end
end
