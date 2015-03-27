xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title t('site_name')
    xml.link t('site_link')
    xml.pubDate Time.now.to_s(:rfc822)
    xml.description t('site_description')
    xml.language 'en-us'

    #head line
     xml.item do
      xml.title @head_line["title"]
      xml.index 1
      xml.category 'topNews'
      xml.img "#{@head_line["img"]}!216x128"
      xml.description @head_line["title"]
      xml.author '36Kr'
      xml.pubDate Time.parse(@head_line["created_at"]).to_s(:rfc822)
      xml.link @head_line["url"]
      xml.guid @head_line["url"]
    end

    @feeds.each_with_index do |feed, index|
      xml.item do
        xml.title feed.title
        xml.index index + 2
        xml.category feed.column.try(:name)
        xml.img "#{feed.cover_real_url}!216x128"
        xml.description feed.summary
        xml.author feed.author.display_name
        xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
        xml.link post_url(feed)
        xml.guid post_url(feed)
      end
    end
  end
end
