xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  cache [ :post, :feed_bdnews, :xml, @feeds.map{|c| c["updated_at"]}.max ] do
    xml.channel do
      xml.title t('site_name')
      xml.link t('site_link')
      xml.pubDate Time.now.to_s(:rfc822)
      xml.description t('site_description')
      xml.language 'en-us'

      #top news
      feed_first = @feeds.first
      if feed_first
        xml.item do
          xml.title feed_first.title
          xml.index 1
          xml.category 'topNews'
          xml.img "#{feed_first.cover_real_url}!216x128"
          xml.description feed_first.summary
          xml.author feed_first.author.display_name
          xml.pubDate feed_first.published_at && feed_first.published_at.to_s(:rfc822)
          xml.link post_url(feed_first)
          xml.guid post_url(feed_first)
        end
      end

      @feeds.each_with_index do |feed, index|
        next if index == 0
        xml.item do
          xml.title feed.title
          xml.index index + 1
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
end
