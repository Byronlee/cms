require 'ftp_sync'

namespace :assets do
  desc 'sync assets to cdns'
  task :cdn => :environment do
    ftp = FtpSync.new("v1.ftp.upyun.com", "36krfiles/kryptoners", "36krfinal", true)
    ftp.sync("#{Rails.root}/public/assets/", "/assets")
  end
end