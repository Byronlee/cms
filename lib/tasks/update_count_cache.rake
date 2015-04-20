namespace :update_count_cache do
  desc 'update users favorites count'
  task :user_favorites_count => :environment do
    User.order("id asc").each do |user|
      favorites_count = user.favorites.count
      User.update_counters user.id, favorites_count: favorites_count
      puts "[#{Time.now}]user##{user.id}.favorites_count => #{favorites_count}"
    end
  end

  desc 'update posts favorites count'
  task :post_favorites_count => :environment do
    Post.order("url_code desc").each do |post|
      favorites_count = post.favoriters.count
      Post.update_counters post.id, favorites_count: favorites_count
      puts "[#{Time.now}]post##{post.url_code}.favorites_count => #{favorites_count}/#{post.favorites.count}"
    end
  end
end