require 'faraday'

module Seo

  def self.writer post
    template_id = 'www-article'
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{post.url_code}"
    params = { content: post.content, title: post.title, keywords: post.tag_list.to_s, description: post.summary }
    response = Faraday.send(:put, url , params)
  end

  def self.read url_code
    template_id = 'www-article'
    url = "#{Settings.kr_seo_server.send("#{Rails.env}_url")}/internal/seo/meta/#{template_id}/#{url_code}"
    response = Faraday.send(:get, url)
  end

end
