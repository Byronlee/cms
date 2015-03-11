class ChangePostsCover < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.change :cover, :text
    end
  end

  def down
    change_table :posts do |t|
      t.change :cover, :string
    end
  end
end
