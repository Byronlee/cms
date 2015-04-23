xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('site_name')
    xml.language 'zh-cn'
    xml.pubDate @feeds.first.published_at
    xml.generator '36氪-关注互联网创业'
    xml.description t('site_description')
    xml.link t('site_link')

    for feed in @feeds
      xml.item do
        xml.title feed.title
        xml.description feed.content
        xml.pubDate feed.published_at
        xml.category feed.column.name
        xml.link post_url(feed)
        xml.guid post_url(feed)
        xml.source t('site_name')
        xml.author feed.author.name
        xml.link_3g post_url(feed)
      end
    end
  end
end
