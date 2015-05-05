namespace :scheduler do
  desc 'update hot posts cache'
  task :update_hot_posts_cache => :environment do
    HotPostsComponentWorker.new.perform
  end
end