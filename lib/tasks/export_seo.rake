namespace :seo do
  desc 'Export seo robort text'
  task :export_seo_posts_text => :environment do
    seo_posts_export_file ||= "#{Rails.root}/public/seo-1.txt"
    Dir.mkdir(File.dirname(seo_posts_export_file)) if !FileTest.exists?(File.dirname(seo_posts_export_file))
    posts = Post.published.recent
    CSV.open(seo_posts_export_file, "wb") do |csv2|
      #http://staging.36kr.com/p/5037751.html
      posts.each_with_index do |post, i|
        csv2 << [ "http://www.36kr.com/p/#{post.url_code}.html" ]
      end
      #http://staging.36kr.com/clipped/10062.html
      Newsflash.recent.each do |newsflash|
        csv2 << [ "http://www.36kr.com/clipped/#{newsflash.id}.html" ]
      end
      #http://staging.36kr.com/columns/fun
      Column.headers.each do |column|
        csv2 << [ "http://www.36kr.com/columns/#{column.slug}.html" ]
      end
      #http://staging.36kr.com/posts/fanyao
      User.recent_editor.each do |user|
        csv2 << [ "http://www.36kr.com/posts/#{user.domain}.html" ] if user.domain
      end
    end
  end

  desc 'Export seo robort text'
  task :export_seo_tags_text => :environment do
    seo_tags_export_file ||= "#{Rails.root}/public/seo-2.txt"
    Dir.mkdir(File.dirname(seo_tags_export_file)) if !FileTest.exists?(File.dirname(seo_tags_export_file))
    tags = ActsAsTaggableOn::Tag.all.order('taggings_count desc')#.limit(10).map(&:name)
    CSV.open(seo_tags_export_file, "wb") do |csv2|
      #http://staging.36kr.com/tag/专栏文章
      tags.each_with_index do |tag, i|
        csv2 << [ "http://www.36kr.com/tag/#{tag.name}.html" ]
      end
    end
  end

end
