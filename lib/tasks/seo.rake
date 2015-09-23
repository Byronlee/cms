require File.join(Rails.root, 'lib/seo.rb')

namespace :seo do
  desc 'Writer seo keyword'
  task :writer => :environment do
    Post.published.each do |post|
      Seo.writer post
    end
  end

  desc 'Read seo keyword'
  task :read, [:url_code] => :environment do |t, args|
      Seo.read args[:url_code]
  end

end
