namespace :users do
  desc '邀请经典站回迁用户使用36Kr通行证归位'
  task invite_ghosts: :environment do
    conditions = User.where(krypton_passport_invitation_sent_at: nil).
      where.not(id: Authentication.where(provider: :krypton).select(:user_id).distinct)
    [:weibo, :qq_connect].each do |provider|
      conditions = conditions.where("email not like '#{provider}+%@36kr.com'")
    end
    total_count = conditions.count
    puts "共需邀请 #{total_count} 位用户"
    succesed = failed = 0
    progressbar = ProgressBar.create total: total_count, length: 40
    conditions.find_each do |user|
      progressbar.increment
      if Krypton::Passport.invite(user.email)
        succesed += 1
        user.update krypton_passport_invitation_sent_at: Time.noww
      else
        failed += 1
      end
    end
    puts "共邀请了 #{total_count} 名用户, 成功邀请 #{succesed} 名, 失败 #{failed} 名"
  end

  task p: :environment do
    progressbar = ProgressBar.create
    100.times.each { progressbar.increment }
  end
end
