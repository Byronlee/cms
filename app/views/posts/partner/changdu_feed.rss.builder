xml.instruct! :xml, :version => "1.0"
xml.rss 'xmlns:content' => "http://purl.org/rss/1.0/modules/content/", :version => "2.0" do
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
          xml.category feed.column.name
          xml.description do
            xml.cdata! feed.summary
          end
          xml.content do
            xml.cdata! sanitize_tags feed.content
          end
          xml.pubDate feed.published_at && feed.published_at.to_s(:rfc822)
          xml.link do
            xml.cdata! "#{post_url feed.url_code, utm_source: params[:partner]}"
          end
          xml.guid "#{post_url feed.url_code, utm_source: params[:partner]}"
          xml.source t('site_name')
          xml.author feed.author.display_name
          xml.tags feed.tag_list
          xml.link_3g post_url(feed)
          xml.related do
            for relate_feed in feed.related_posts
              xml.item do
                xml.title do
                  xml.cdata! relate_feed.title
                end

                xml.link do
                  xml.cdata! "#{post_url relate_feed.url_code, utm_source: params[:partner]}"
                end
              end
            end
          end
        end
      end
    end
  end
end
