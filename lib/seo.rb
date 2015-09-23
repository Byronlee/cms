require 'faraday'

module Seo

  def self.writer post
    start_time = Time.now
    template_id = 'www-article'
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{post.url_code}"
    params = { content: post.content, title: post.title, keywords: post.tag_list.to_s, description: post.summary }
    response = Faraday.send(:put, url , params)
    msg = ActiveSupport::JSON.decode(response.body)
    end_time = Time.now
    puts "#{end_time - start_time} : #{msg}"
  end

  def self.read url_code
    start_time = Time.now
    template_id = 'www-article'
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{url_code}"
    response = Faraday.send(:get, url)
    msg = ActiveSupport::JSON.decode(response.body)
    end_time = Time.now
    puts "#{end_time - start_time} : #{msg}"
  end

end
