require File.join(Rails.root, 'lib/seo.rb')

namespace :seo do
  desc 'Writer seo keyword'
  task :push, [:template_id, :limit] => :environment do |t, args|
    template_id, limit = args[:template_id], args[:limit].to_i
    case template_id
    when 'www-article'
      push_article(template_id, limit)
    when 'www-home'
      push_home(template_id)
    when 'www-newsflashes'
      push_newsflashes(template_id, limit)
    when 'www-posts'
      push_authors(template_id, limit)
    else
      puts '---'
    end
  end

  def push_article(template_id, limit)
    if limit == 0
      posts = Post.published.recent
    else
      posts = Post.published.recent.limit(limit)
    end
    total_count = posts.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    posts.each do |post|
      params = { id: post.url_code, content: post.content, title: post.title, keywords: post.tag_list.to_s, description: post.summary, author: post.author.display_name }
      response = Seo.writer template_id, params
      data = ActiveSupport::JSON.decode(response.body)
      if response.success? and data['code'] == 0
        #puts data
        progressbar.increment
        succesed += 1
      else
        progressbar.decrement
        failed += 1
      end
    end
    puts "共提交 #{total_count} 个文章, 成功提交 #{succesed} 个文章, 失败 #{failed} 个文章"
  end

  def push_newsflashes(template_id, limit)
    if limit == 0
      newsflashs = Newsflash.recent
    else
      newsflashs = Newsflash.recent.limit(limit)
    end
    total_count = newsflashs.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    newsflashs.each do |newsflash|
      if newsflash.description_text
        params = { id: newsflash.id, content: newsflash.description_text, title: newsflash.hash_title, keywords: newsflash.tag_list.to_s, description: newsflash.description_text, author: newsflash.author.display_name }
        response = Seo.writer template_id, params
        data = ActiveSupport::JSON.decode(response.body)
        #puts data
        if response.success? and data['code'] == 0
          progressbar.increment
          succesed += 1
        else
          progressbar.decrement
          failed += 1
        end
      end
    end
    puts "共提交 #{total_count} 个快讯, 成功提交 #{succesed} 个快讯, 失败 #{failed} 个快讯"
  end

  def push_authors(template_id, limit)
    if limit == 0
      users = User.recent_editor
    else
      users = User.recent_editor.limit(limit)
    end
    total_count = users.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    users.each do |user|
      #if user.domain.present?
        params = { id: user.id, content: user.display_name, title: user.display_name, keywords: user.display_name, description: user.display_name, author: user.display_name }
        response = Seo.writer template_id, params
        data = ActiveSupport::JSON.decode(response.body)
        #puts "#{data}-#{user.display_name}"
        if response.success? and data['code'] == 0
          progressbar.increment
          succesed += 1
        else
          progressbar.decrement
          failed += 1
        end
      #end
    end
    puts "共提交 #{total_count} 个作者, 成功提交 #{succesed} 个作者, 失败 #{failed} 个作者"
  end

  def push_home(template_id)
    params = { id: 0, content: 'home', title: 'home', keywords: '36kr', description: 'home' }
    response = Seo.writer template_id, params
    data = ActiveSupport::JSON.decode(response.body)
    #puts "#{data}" #if response.success? and data['code'] == 0
  end

  desc 'Read seo keyword'
  task :pull, [:template_id, :limit] => :environment do |t, args|
    template_id, limit = args[:template_id], args[:limit].to_i
    case template_id
    when 'www-article'
      pull_article(template_id, limit)
    when 'www-newsflashes'
      pull_newsflashes(template_id, limit)
    when 'www-posts'
      pull_authors(template_id, limit)
    when 'www-home'
      pull_home(template_id)
    when 'site-header'
      pull_site_header(template_id)
    when 'site-footer'
      pull_site_footer(template_id)
    else

    end
  end

  def pull_article(template_id, limit)
    if limit == 0
      posts = Post.published.recent
    else
      posts = Post.published.recent.limit(limit)     
    end
    total_count = posts.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    redis_hash = Redis::HashKey.new(template_id)
    posts.each do |post|
      response = Seo.read template_id, post.url_code
      data = ActiveSupport::JSON.decode(response.body)
      if response.success? and data['code'] == 0
        redis_hash[post.url_code] = data['data']
        #puts data
        #post.update_column(:seo_meta, data['data'])
        progressbar.increment
        succesed += 1
      else
        progressbar.decrement
        failed += 1
      end
    end
    puts "共更新 #{total_count} 个文章, 成功更新 #{succesed} 个文章, 失败 #{failed} 个文章"
  end

  def pull_newsflashes(template_id, limit)
    redis_hash = Redis::HashKey.new(template_id)
    response = Seo.read template_id, 0
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      redis_hash[0] = data['data']
      puts data
    end
  end

  def pull_newsflashes_detil(template_id, limit)
    if limit == 0
      newsflashs = Newsflash.recent
    else
      newsflashs = Newsflash.recent.limit(limit)
    end
    total_count = newsflashs.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    redis_hash = Redis::HashKey.new(template_id)
    newsflashs.each do |newsflash|
      response = Seo.read template_id, newsflash.id
      data = ActiveSupport::JSON.decode(response.body)
      if response.success? and data['code'] == 0
        redis_hash[newsflash.id] = data['data']
        #puts data
        #post.update_column(:seo_meta, data['data'])
        progressbar.increment
        succesed += 1
      else
        progressbar.decrement
        failed += 1
      end
    end
    puts "共更新 #{total_count} 个快讯, 成功更新 #{succesed} 个快讯, 失败 #{failed} 个快讯"
  end

    def pull_authors_disable(template_id, limit)
    redis_hash = Redis::HashKey.new(template_id)
    response = Seo.read template_id, 0
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      redis_hash[0] = data['data']
      puts data
    end
  end

  def pull_authors(template_id, limit)
    if limit == 0
      users = User.recent_editor
    else
      users = User.recent_editor.limit(limit)
    end
    total_count = users.count
    succesed = failed = 0
    progressbar = ProgressBar.create(total: total_count, format: '%a %bᗧ%i %p%% %t')
    redis_hash = Redis::HashKey.new(template_id)
    users.each do |user|
      #if user.domain.present?
        response = Seo.read template_id, user.id
        data = ActiveSupport::JSON.decode(response.body)
        if response.success? and data['code'] == 0
          redis_hash[user.display_name] = data['data']
          #puts "#{data}-#{user.display_name}"
          progressbar.increment
          succesed += 1
        else
          progressbar.decrement
          failed += 1
        end
      #end
    end
    puts "共更新 #{total_count} 个作者, 成功更新 #{succesed} 个作者, 失败 #{failed} 个作者"
  end

  def pull_home(template_id)
    redis_hash = Redis::HashKey.new(template_id)
    response = Seo.read template_id, 0
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      redis_hash[0] = data['data']
      puts data
    end
  end

  def pull_site_header(template_id)
    redis_hash = Redis::HashKey.new(template_id)
    response = Seo.read_header_footer(template_id)
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      redis_hash['header'] = data['data']['header']
      puts data['data']['header']
    end
  end

  def pull_site_footer(template_id)
    redis_hash = Redis::HashKey.new(template_id)
    response = Seo.read_header_footer(template_id)
    data = ActiveSupport::JSON.decode(response.body)
    if response.success? and data['code'] == 0
      redis_hash['footer'] = data['data']['footer']
      puts data['data']['footer']
    end   
  end

  desc 'Test Read seo keyword'
  task :read, [:template_id, :url_code] => :environment do |t, args|
    template_id = args[:template_id]
    response = Seo.read template_id, args[:url_code]
    data = ActiveSupport::JSON.decode(response.body)
    puts "返回消息 #{data}"
  end

end
