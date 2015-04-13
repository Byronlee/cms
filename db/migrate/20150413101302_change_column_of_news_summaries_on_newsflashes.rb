class ChangeColumnOfNewsSummariesOnNewsflashes < ActiveRecord::Migration
  def up
    change_table :newsflashes do |t|
      t.change :news_summaries, :string, limit: 5000, :array => true, default: []
    end
  end

  def down
    change_table :newsflashes do |t|
      t.change :news_summaries, :string, limit: 255, :array => true, default: []
    end
  end
end