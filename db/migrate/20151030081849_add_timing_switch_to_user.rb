class AddTimingSwitchToUser < ActiveRecord::Migration
  def change
    add_column :users, :timing_switch, :string, default: 'on'
  end
end
