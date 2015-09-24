require File.join(Rails.root, 'lib/seo.rb')

namespace :seo do
  desc 'Writer seo keyword'
  task :push => :environment do
    posts = Post.published.recent
    total_count = posts.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    posts.each do |post|
      response = Seo.writer post
      #msg = ActiveSupport::JSON.decode(response.body)
      if response.success?
        progressbar.increment
        succesed += 1
      else
        progressbar.decrement
        failed += 1
      end
    end
    puts "共提交 #{total_count} 个文章, 成功提交 #{succesed} 个文章, 失败 #{failed} 个文章"
  end

  desc 'Read seo keyword'
  task :pull, [:url_code] => :environment do |t, args|
    posts = Post.published.recent
    total_count = posts.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    posts.each do |post|
      response = Seo.read post.url_code
      data = ActiveSupport::JSON.decode(response.body)
      if response.success? and data['code'] == 0
        post.update_column(:seo_meta, data['data'])
        progressbar.increment
        succesed += 1
      else
        progressbar.decrement
        failed += 1
      end
    end
    puts "共更新 #{total_count} 个文章, 成功更新 #{succesed} 个文章, 失败 #{failed} 个文章"
  end

  desc 'Test Read seo keyword'
  task :read, [:url_code] => :environment do |t, args|
    response = Seo.read args[:url_code]
    data = ActiveSupport::JSON.decode(response.body)
    puts "返回消息 #{data}"
  end

end
