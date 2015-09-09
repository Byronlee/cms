class AddColumnDisplayInInfoflowToNewsflashes < ActiveRecord::Migration
  def change
    add_column :newsflashes, :display_in_infoflow, :boolean
  end
end
