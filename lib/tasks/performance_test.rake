namespace :performance do
  desc 'sync page views count to database'
  task :page_views_access => :environment do
    Post.order("id asc").all.each_with_index do |post, index|
      post.increase_views_count
      puts "#{Time.now} access[#{index}] #{post.id}"
    end
  end
end