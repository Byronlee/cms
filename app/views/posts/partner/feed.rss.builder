xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :post, :partner_feed, params[:parnter], :xml, @feeds.map{|c| c["updated_at"]}.max ] do
    xml.channel do
      xml.title t('site_name')
      xml.language 'zh-cn'
      xml.pubDate @feeds.first && @feeds.first.published_at.to_s(:rfc822)
      xml.generator t('site.name').gsub('|', '-')
      xml.description t('site_description')
      xml.link do
        xml.cdata! t('site_link')
      end

      for feed in @feeds
        xml.item do
          xml.title do
            xml.cdata! feed.title
          end
          xml.link do
            xml.cdata! "#{post_url feed.url_code, utm_source: params[:partner]}"
          end
          xml.link_3g post_url(feed)
          xml.description do
            xml.cdata! feed.summary
          end
          xml.content do
            xml.cdata! sanitize_tags feed.content
          end
          xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
          xml.guid "#{post_url feed.url_code, utm_source: params[:partner]}"
          xml.source t('site_name')
          xml.category feed.column.name
          xml.author feed.author.display_name
          xml.tags feed.tag_list
        end
      end
    end
  end
end
