class AddColumnSlugToSites < ActiveRecord::Migration
  def change
    add_column :sites, :slug, :string
	  add_index(:sites, :slug, using: :hash)
  end
end
