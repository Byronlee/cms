require 'faraday'

namespace :seo do
  desc 'Baidu update data'
  task :post_push_baidu => :environment do
    url = 'http://data.zz.baidu.com/urls?site=36kr.com&token=t6nDUVNK5Hbdipj2'
    posts = Post.select('url_code').published_on(Date.today).order('published_at desc')
    urls = []
    posts.each do |post|
      urls << "https://36kr.com/p/#{post.url_code}.html"
    end
    response = Faraday.post do |req|
      req.url url
      req.headers['Content-Type'] = 'text/plain'
      req.body = urls.join("\n")
    end
    puts response.body
  end

  desc 'Export seo robort text'
  task :export_seo_posts_text => :environment do
    seo_posts_export_file ||= "#{Rails.root}/public/seo-1.txt"
    Dir.mkdir(File.dirname(seo_posts_export_file)) if !FileTest.exists?(File.dirname(seo_posts_export_file))
    posts = Post.published.recent
    newsflashs = Newsflash.recent
    columns = Column.headers
    users = User.recent_editor
    progressbar = ProgressBar.create(total: posts.count, format: '%a %bᗧ%i %p%% %t')
    CSV.open(seo_posts_export_file, "wb") do |csv2|
      #http://staging.36kr.com/p/5037751.html
      posts.each do |post|
        url = "http://36kr.com/p/#{post.url_code}.html"
        if Faraday.send(:get, url).success?
          csv2 << [ url ]
          progressbar.increment
        end
      end
      #http://staging.36kr.com/clipped/10062.html
      newsflashs.each do |newsflash|
        url = "http://36kr.com/clipped/#{newsflash.id}.html"
        csv2 << [ url ] if Faraday.send(:get, url).success?
      end
      #http://staging.36kr.com/columns/fun
      columns.each do |column|
        url = "http://36kr.com/columns/#{column.slug}.html"
        csv2 << [ url ] if Faraday.send(:get, url).success?
      end
      #http://staging.36kr.com/posts/fanyao
      users.each do |user|
        if user.domain
          url = "http://36kr.com/posts/#{user.domain}.html"
          csv2 << [ url ] if Faraday.send(:get, url).success?
        end

      end
    end
  end

  desc 'Export seo robort text'
  task :export_seo_tags_text => :environment do
    seo_tags_export_file ||= "#{Rails.root}/public/seo-2.txt"
    Dir.mkdir(File.dirname(seo_tags_export_file)) if !FileTest.exists?(File.dirname(seo_tags_export_file))
    tags = ActsAsTaggableOn::Tag.all.order('taggings_count desc')#.limit(10).map(&:name)
    progressbar = ProgressBar.create(total: tags.count, format: '%a %bᗧ%i %p%% %t')
    CSV.open(seo_tags_export_file, "wb") do |csv2|
      #http://staging.36kr.com/tag/专栏文章
      tags.each do |tag|
        url = "http://36kr.com/tag/#{URI.encode(tag.name)}.html"
        if Faraday.send(:get, url).success?
          csv2 << [ url ]
          progressbar.increment
        end
      end
    end
  end

end
