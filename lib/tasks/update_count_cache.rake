namespace :update_count_cache do
  desc 'update user favorites count'
  task :user_favorites_count => :environment do
    User.order("id asc").each do |user|
      favorites_count = user.favorites.count
      User.update_counters user.id, favorites_count: favorites_count
      puts "[#{Time.now}]user##{user.id}.favorites_count => #{favorites_count}"
    end
  end
end