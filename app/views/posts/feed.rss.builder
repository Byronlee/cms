xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('site_name')
    xml.description t('site_description')
    xml.link t('site_link')

    for feed in @feeds
      xml.item do
        xml.title feed.title
        xml.description feed.content
        xml.pubDate feed.created_at.to_s(:rfc822)
        xml.link post_url(feed)
        xml.guid post_url(feed)
      end
    end
  end
end
