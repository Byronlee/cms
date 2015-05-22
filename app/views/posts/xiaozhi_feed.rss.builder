xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('site_name')
    xml.language 'zh-cn'
    xml.pubDate @feeds.first && @feeds.first.published_at
    xml.generator '36氪-关注互联网创业'
    xml.description t('site_description')
    xml.link do
      xml.cdata! t('site_link')
    end

    for feed in @feeds
      xml.item do
        xml.title feed.title
        xml.category feed.column.name
        xml.description do
          xml.cdata! feed.summary
        end
        xml.content do
          xml.cdata! feed.content
        end
        xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
        xml.link do
          xml.cdata! "http://preview.36kr.com/xiaozhi/#{feed.url_code}"
        end
        xml.guid "http://preview.36kr.com/xiaozhi/#{feed.url_code}"
        xml.source t('site_name')
        xml.author feed.author.name
        xml.tags feed.tag_list
        xml.link_3g post_url(feed)
      end
    end
  end
end
