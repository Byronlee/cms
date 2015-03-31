namespace :page_views do
  desc 'sync page views count to database'
  task :persist => :environment do
    index = 1
    $redis.hscan_each("page_views") do |k, v|
      model_name, id, attr = k.split('#')
      model = model_name.classify.constantize.find_by_id(id)
      next unless model #model not found
      model.instance_eval("persist_#{attr}(skip_callbacks: true)")
      puts "#{Time.now} process[#{index}] #{k} => #{v} done"
      index += 1
    end

    puts 'perform the worker to update hot posts cache'
    HotPostsComponentWorker.new.perform
  end

  desc 'sync old page views to post'
  task :perisist_old_post => :environment do
    index = 1
    $redis.hscan_each("posts", match:"views_count*") do |k, v|
      id = k.split('_').last
      post = Post.find_by_id(id)
      next unless post #post not found
      if post.views_count < v.to_i
        post.update_column(:views_count, v.to_i)
      end
      puts "#{Time.now} process[#{index}] #{k} => #{v} done"
      index += 1
    end

    puts 'perform the worker to update hot posts cache'
    HotPostsComponentWorker.new.perform
  end
end
