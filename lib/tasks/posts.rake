namespace :posts do
  desc 'update all related posts ids info'
  task :update_related_post_url_codes => :environment do
    Post.order("id desc").all.each_with_index do |post, index|
      posts = post.find_related_tags.published.where.not(id: post.id).limit(3)
      posts = post.author.posts.published.where.not(id: post.id).recent.limit(3) if posts.blank?
      url_codes = posts.map(&:url_code)
      post.update_attribute(:related_post_url_codes, url_codes)
      puts "#{Time.now} process[#{index}] #{post.url_code} => #{url_codes} done"
    end
  end
end