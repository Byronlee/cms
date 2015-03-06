class AddColumnSlugToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :slug, :string
  end
end
