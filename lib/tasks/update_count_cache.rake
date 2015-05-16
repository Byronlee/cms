namespace :update_count_cache do
  desc 'update users favorites count'
  task :user_favorites_count => :environment do
    total_count = User.count
    User.order("id asc").each_with_index do |user, index|
      User.reset_counters user.id, :favorites
      puts "[#{index + 1}/#{total_count}][#{Time.now}]user##{user.id} done"
    end
  end

  desc 'update posts favorites count'
  task :post_favorites_count => :environment do
    total_count = Post.count
    Post.order("url_code desc").each_with_index do |post, index|
      Post.reset_counters post.id, :favorites
      puts "[#{index + 1}/#{total_count}][#{Time.now}]post##{post.url_code} done"
    end
  end
end