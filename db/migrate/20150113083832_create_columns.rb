class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :name
      t.text :introduce

      t.timestamps
    end
  end
end
