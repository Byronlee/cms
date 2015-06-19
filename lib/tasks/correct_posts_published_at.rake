namespace :correct_data do
  desc 'force posts published_at to created_at where url_code little than 200,000'
  task :correct_posts_published_at => :environment do
    total_count = Post.where("url_code < 200000").count
    Post.where("url_code < 200000").order("url_code asc").each_with_index do |post, index|
      post.update_attribute(:published_at, post.created_at)
      puts "[#{index + 1}/#{total_count}][#{Time.now}]post##{post.url_code} done"
    end
  end
end