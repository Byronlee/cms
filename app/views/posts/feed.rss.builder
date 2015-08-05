xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :post, :feed, :xml, @feeds.map{|c| c["updated_at"]}.max ] do
    xml.channel do
      xml.title t('site_name')
      xml.language 'zh-cn'
      xml.pubDate @feeds.first && @feeds.first.published_at
      xml.generator t('site.name').gsub('|', '-')
      xml.description t('site_description')
      xml.link t('site_link')

      for feed in @feeds
        xml.item do
          xml.title feed.title
          xml.category feed.column.name
          xml.description sanitize_tags feed.content.gsub(/<u>/, '<mark>').gsub(/<\/u>/, '</mark>')
          xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
          xml.link post_url(feed)
          xml.guid post_url(feed)
          xml.source t('site_name')
          xml.author feed.author.name
          xml.link_3g post_url(feed)
        end
      end
    end
  end
end
