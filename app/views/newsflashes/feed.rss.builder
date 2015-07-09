xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  cache [ :newflash, :feed, :xml, @feeds.map(&:updated_at).max, params[:utm_source].to_s] do
    xml.channel do
      xml.title @ptype
      xml.language 'zh-cn'
      xml.pubDate @feeds.first && @feeds.first.created_at
      xml.generator t('site.name').gsub('|', '-')
      xml.description t('site_description')
      xml.link t('site_link')

      for feed in @feeds
        xml.item do
          xml.title feed.hash_title
          xml.description feed.description_text
          xml.pubDate feed.created_at && feed.created_at.to_s(:rfc822)
          xml.link newsflash_show_url(feed) + (params[:utm_source].present? ? ("?utm_source=" + params[:utm_source]) : "")
          xml.guid newsflash_show_url(feed) + (params[:utm_source].present? ? ("?utm_source=" + params[:utm_source]) : "")
          xml.source t('site_name')
          xml.author feed.author.try(:name) if !!feed.author
        end
      end
    end
  end
end