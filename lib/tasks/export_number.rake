namespace :export do
  desc 'export user info'
  task :export_user_info_number => :environment do

=begin
    users = User.all.order('id')
    users_export_file ||= "#{Rails.root}/tmp/data/users-#{DateTime.now.strftime("%F")}.csv"
    Dir.mkdir(File.dirname(users_export_file)) if !FileTest.exists?(File.dirname(users_export_file))

    CSV.open(users_export_file, "wb") do |csv|
      csv << [ 'id', 'email',' sso_id', '姓名', '手机号', '注册时间']
      users.each_with_index do |user, i|
        auth = user.krypton_authentication
        name = auth.info['name'] if auth
        csv << [ user.id, user.email, user.sso_id, name || user.name, user.phone, user.created_at ]
      end
    end
=end

#=begin
    posts_export_file ||= "#{Rails.root}/tmp/data/posts-#{DateTime.now.strftime("%F")}.csv"
    Dir.mkdir(File.dirname(posts_export_file)) if !FileTest.exists?(File.dirname(posts_export_file))
    posts = Post.all.order('url_code')
    CSV.open(posts_export_file, "wb") do |csv2|
      csv2 << [ 'url_code']#, '文章标题', '评论数', '收藏数', '浏览击数']
      posts.each do |post|
        csv2 << [ post.url_code ]#, post.title, post.comments_counts, post.favorites_count, post.cache_views_count ]
      end
    end
#=end

  end
end
