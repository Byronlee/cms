namespace :posts do
  desc 'update all related posts ids info'
  task :update_related_post_url_codes => :environment do
    total_count = Post.published.count
    # progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    Post.published.where("related_post_url_codes <> '{}' ").recent.find_each.with_index do |post, index|
    	if post.related_post_url_codes.blank?
        post.update_column(:related_post_url_codes, post.get_related_post_url_codes)
        puts "##{Time.now} process[#{index}/#{total_count}] #{post.url_code} => #{post.related_post_url_codes} done"
        # progressbar.increment
      end
    end
    puts "done"
  end
end