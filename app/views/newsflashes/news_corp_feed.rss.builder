xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :post, params[:coop], :xml, @news.map{|c| c["updated_at"]}.max ] do
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

      for flash in @news
        xml.item do
          xml.author do
            xml.cdata! '36氪'
          end
          xml.title do
            xml.cdata! flash.hash_title
          end
          xml.category do
            xml.cdata! '快讯'
          end
          xml.link do
            xml.cdata! "#{Settings.site}/newsflash/coop/#{flash.id}.html?utm_source=#{params[:coop]}"
          end
          xml.description do
              xml.cdata! flash.description_text.present?? flash.description_text : ''
          end
          xml.pubDate do
              xml.cdata! flash.created_at.to_s(:rfc822)
          end
          xml.source do
            xml.cdata! flash.news_url
          end
        end
      end
    end
  end
end