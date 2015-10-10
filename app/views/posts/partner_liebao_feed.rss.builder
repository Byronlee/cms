xml.rss 'xmlns:content' => "http://purl.org/rss/1.0/modules/content/", :version => "2.0" do
  cache [ :post, :partner_feed, params[:parnter], :xml, @feeds.map{|c| c["updated_at"]}.max ] do
    xml.channel do
      xml.title t('site_name')
      xml.link do
        xml.cdata! t('site_link')
      end
      xml.description t('site_description')
      xml.language 'zh-cn'
      xml.pubDate @feeds.first && @feeds.first.published_at.to_s(:rfc822)

      for feed in @feeds
        xml.item do
          xml.title do
            xml.cdata! feed.title
          end
          xml.link do
            xml.cdata! "#{post_url feed.url_code, utm_source: params[:partner]}"
          end
          xml.description do
            xml.cdata! feed.summary
          end
          xml.content:encoded do
            xml.cdata! sanitize_tags feed.content
          end
          xml.category feed.column.name
          xml.author feed.author.name
          xml.source t('site_name')
          xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
        end
      end
    end
  end
end
