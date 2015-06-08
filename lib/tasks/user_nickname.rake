namespace :users do
  desc '邀请经典站回迁用户使用36Kr通行证归位'
  task fix_sso_nickname: :environment do
    users = User.where.not(sso_id: nil).order('created_at desc')
    total_count = users.count
    puts "共需修改 #{total_count} 位用户的 Nickname"
    succesed = failed = 0
    progressbar = ProgressBar.create total: total_count

    users.each do |user|
      progressbar.increment
      if Krypton::Passport.update(user.sso_id, { nickname: user.name })
        succesed += 1
      else
        failed += 1
      end
    end
    puts "共同步了 #{total_count} 名用户, 成功同步 #{succesed} 名, 失败 #{failed} 名"
  end
end
