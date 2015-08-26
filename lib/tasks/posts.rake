namespace :posts do
  desc 'update all related posts ids info'
  task :update_related_post_url_codes => :environment do
    Post.order("id desc").all.each_with_index do |post, index|
    	if post.related_post_url_codes.blank?
        post.related_post_url_codes =  post.get_related_post_url_codes
        post.save
      end
      puts "#{Time.now} process[#{index}] #{post.url_code} => #{post.related_post_url_codes} done"
    end
  end
end