class ChangePostsSummary < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.change :summary, :text
    end
  end

  def down
    change_table :posts do |t|
      t.change :summary, :string
    end
  end
end
