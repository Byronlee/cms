class CreateFragmentTemplates < ActiveRecord::Migration
  def change
    create_table :fragment_templates do |t|
      t.string :key
      t.string :name
      t.text :content
      t.string :content_type

      t.timestamps
    end

    add_index :fragment_templates, :key, unique: true
  end
end
