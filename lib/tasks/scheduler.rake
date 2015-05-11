# TODO: 使用whenever来做定时任务
namespace :scheduler do
  desc 'update hot posts cache'
  task :update_hot_posts_cache => :environment do
    HotPostsComponentWorker.new.perform
  end
end