namespace :tags do
  desc '迁移文章栏目tags'
  task tags_to_post: :environment do
    columns = Column.all.order(id: :desc)
    succesed = failed = 0
    columns.each do |c|
      posts = c.posts.recent.limit(10)
      total_count = posts.count
      #progressbar = ProgressBar.create total: total_count
      puts "专栏 #{c.name} 共迁移 #{total_count} 个文章"
      posts.each do |p|
        #progressbar.increment
        p.tag_list.add c.slug
        if p.save
         succesed += 1 
         #puts "#{p.errors.messages}: #{p.tag_list.size} #{c.slug}"
         else
          failed += 1
          puts "#{p.errors.messages}: #{p.id} #{p.tag_list.size} #{c.slug}"
        end
      end
    end
    puts "共迁移 #{columns.count} 个专栏, 成功迁移 #{succesed} 个文章, 失败 #{failed} 个文章"
  end
end

