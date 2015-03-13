namespace :data do
  desc '统计专栏文章数'
  task calculate: :environment do
    result = ActiveRecord::Base.connection.execute("select column_id, count(id) from posts group by column_id;")
    succesed = failed = 0
    progressbar = ProgressBar.create total: result.to_a.size
    result.to_a.each do |r|
      progressbar.increment
      if Column.find(r["column_id"]).update_attribute(:posts_count,  r["count"])
         succesed += 1
      else
        failed += 1
      end
    end
  end
end
