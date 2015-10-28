xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :post, params[:coop], :xml, @feeds.map{|c| c["updated_at"]}.max ] do
    xml.channel do
      xml.title do
        xml.cdata! '36氪 关注互联网创业'
      end
      xml.image do
        xml.url do
          xml.cdata! 'http://a.36krcnd.com/nil_class/e9dfee47-68bd-4121-b29d-dc06f058588b/36kr.png'
        end
      end
      xml.link do
        xml.cdata! t('site_link')
      end

      for feed in @feeds
        xml.item do
          xml.author do
            xml.cdata! feed.author.name
          end
          xml.title do
            xml.cdata! feed.title
          end
          xml.category do
            xml.cdata! feed.column.name
          end
          xml.link do
            xml.cdata! "#{Settings.site}/coop/#{params[:coop]}/#{feed.url_code}.html?utm_source=#{params[:coop]}"
          end
          xml.description do
            if params[:coop] == 'yidian'
              xml.cdata! feed.content
            else
              xml.cdata! feed.summary
            end
          end
          xml.pubDate do
            if params[:coop] == 'yidian'
              xml.cdata! feed.published_at.to_formatted_s('%Y-%m-%d %H:%M:%S %Z')
            else
              xml.cdata! feed.published_at.to_s(:rfc822)
            end
          end
          xml.source do
            xml.cdata! t('site_name')
          end
        end
      end
    end
  end
end