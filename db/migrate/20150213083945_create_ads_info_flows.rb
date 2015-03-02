class CreateAdsInfoFlows < ActiveRecord::Migration
  def change
    create_table :ads_info_flows do |t|
      t.integer :info_flow_id
      t.integer :ad_id

      t.timestamps
    end
  end
end
