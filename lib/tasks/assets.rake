require 'ftp_sync'

namespace :assets do
  desc 'sync assets to cdns'
  task :cdn => :environment do
    puts "reading manifest file from #{Rails.root}/public/assets/manifest-*.json"
    json = JSON.parse(File.read Dir.glob("#{Rails.root}/public/assets/manifest-*.json").first)
    files = json["assets"].values

    ftp = Net::FTP.new('v1.ftp.upyun.com')
    ftp.login "36krfiles/kryptoners", "36krfinal"
    ftp.passive = true
    puts "connected to assets host.."
    begin
      files.each do |filename|
        puts "uploading asset file: #{Rails.root}/public/assets/#{filename}"
        ftp.put("#{Rails.root}/public/assets/#{filename}", "assets/#{filename}")
      end
    ensure
      ftp.close
    end
    #ftp = FtpSync.new("v1.ftp.upyun.com", "36krfiles/kryptoners", "36krfinal", true)
    #ftp.sync("#{Rails.root}/public/assets/", "/assets")
  end
end