namespace :update_count_cache do
  desc 'update users favorites count'
  task :user_favorites_count => :environment do
    total_count = User.count
    User.order("id asc").each_with_index do |user, index|
      favorites_count = user.favorites.count
      User.update_counters user.id, favorites_count: favorites_count
      puts "[#{index + 1}/#{total_count}][#{Time.now}]user##{user.id}.favorites_count => #{favorites_count}"
    end
  end

  desc 'update posts favorites count'
  task :post_favorites_count => :environment do
    total_count = Post.count
    Post.order("url_code desc").each_with_index do |post, index|
      favorites_count = post.favoriters.count
      Post.update_counters post.id, favorites_count: favorites_count
      puts "[#{index + 1}/#{total_count}][#{Time.now}]post##{post.url_code}.favorites_count => #{favorites_count}/#{post.favorites.count}"
    end
  end
end