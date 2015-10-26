namespace :export do
  desc 'export post info'
  task :export_post_info => :environment do
    posts = Post.all.order(created_at: :desc)
    posts_export_file ||= "#{Rails.root}/tmp/data/posts-info-#{DateTime.now.strftime("%F")}(#{posts.count}).csv"
    Dir.mkdir(File.dirname(posts_export_file)) if !FileTest.exists?(File.dirname(posts_export_file))
    progressbar = ProgressBar.create(total: posts.count, format: '%a %bᗧ%i %p%% %t')
    CSV.open(posts_export_file, "wb") do |csv2|
      csv2 << ['\xEF\xBB\xBF序号','标题','链接','作者','创建时间']
      num = 0
      posts.each do |post|
        csv2 << [num +=1, post.title,"https://36kr.com/p/#{post.url_code}.html", post.author.display_name, post.created_at.strftime('%Y-%m-%d %H:%M:%S')]
        progressbar.increment
      end
    end

  end

end