namespace :export do
	desc 'export user info'
	task :export_user_info_number => :environment do
		users = User.all.order('id')

		users_export_file ||= "#{Rails.root}/tmp/data/users-#{DateTime.now.strftime("%F")}.csv"
        Dir.mkdir(File.dirname(users_export_file)) if !FileTest.exists?(File.dirname(users_export_file))
        CSV.open(users_export_file, "wb") do |csv|
        	csv << [ 'sso_id', '姓名', '手机号']
        	users.each do |user|
			    csv << [ user.sso_id, user.name, user.phone ]
        	end
		end

=begin
		post_export_file ||= "#{Rails.root}/tmp/data/post-#{DateTime.now.strftime("%F")}.csv"
        Dir.mkdir(File.dirname(post_export_file)) if !FileTest.exists?(File.dirname(post_export_file))
        CSV.open(post_export_file, "wb") do |csv2|
        	csv2 << [ 'url_code', '文章标题', '评论数', '收藏数', '浏览击数']
        	columns.each do |column|
			    column.posts.each do |post|
					csv2 << [ post.url_code, post.title, post.comments_counts, post.favorites_count, post.cache_views_count ]
				end
        	end
		end
=end

	end
end