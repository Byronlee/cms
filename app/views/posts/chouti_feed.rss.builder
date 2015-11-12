xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :post, :chouti_feed, :xml, @feeds.map{|c| c["updated_at"]}.max, params[:utm_source].to_s] do
    xml.channel do
      xml.title t('site_name')
      xml.language 'zh-cn'
      xml.pubDate @feeds.first && @feeds.first.published_at
      xml.generator t('site.name').gsub('|', '-')
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
            xml.cdata! sanitize_tags feed.content
          end
          xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
          xml.link do
            xml.cdata! chouti_news_url(feed.url_code) + (params[:utm_source].present? ? ("?utm_source=" + params[:utm_source]) : "")
          end
          xml.guid chouti_news_url(feed.url_code) + (params[:utm_source].present? ? ("?utm_source=" + params[:utm_source]) : "")
          xml.source t('site_name')
          xml.author feed.author.display_name
          xml.tags feed.tag_list
          xml.link_3g post_url(feed) + (params[:utm_source].present? ? ("?utm_source=" + params[:utm_source]) : "")
        end
      end
    end
  end
end
