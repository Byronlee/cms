namespace :page_views do
  desc 'sync old page views to new cache'
  task :perform_old_views_count => :environment do
    index = 1
    $redis.hscan_each("posts", match:"views_count*") do |k, v|
      id = k.split('_').last
      post = Post.find_by_id(id)
      next unless post #post not found
      old_views_count = v.to_i > post.views_count ? v.to_i - post.views_count : 0
      new_cache_key = "Post##{id}#views_count"
      new_value = Redis::HashKey.new('page_views')[new_cache_key]
      if new_value
        Redis::HashKey.new('page_views')[new_cache_key] = new_value.to_i + old_views_count
      else
        Redis::HashKey.new('page_views')[new_cache_key] = post.views_count + old_views_count
      end
      puts "#{Time.now} process[#{index}] #{k} => #{v} done"
      index += 1
    end

    puts 'perform the worker to update hot posts cache'
    HotPostsComponentWorker.new.perform
  end
end