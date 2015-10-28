json.cache! [ :post, :feed, :json, @feeds.map{|c| c["updated_at"]}.max ] do
  json.channel do
    json.title t('site_name')
    json.language 'zh-cn'
    json.pubDate @feeds.first && @feeds.first.published_at
    json.generator t('site.name').gsub('|', '-')
    json.description t('site_description')
    json.link t('site_link')
  end
  for feed in @feeds
    json.item do
      json.title feed.title
      json.category feed.column.name
      json.description  sanitize_tags feed.content.gsub(/<u>/, '<mark>').gsub(/<\/u>/, '</mark>')
      json.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
      json.link post_url(feed)
      json.guid post_url(feed)
      json.source t('site_name')
      json.author feed.author.name
      json.link_3g post_url(feed)
    end
  end
end