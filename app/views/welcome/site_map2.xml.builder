xml.instruct! :xml, :version => "1.0"
xml.urlset :xmlns => "http://36kr.com/sitemap/0.9" do
  @tags.each do |tag|
  	xml.url do
      xml.loc "http://www.36kr.com/tag/#{tag.name}.html"
      xml.lastmod Time.now.strftime("%F")
      xml.changefreq 'weekly'
      xml.priority '0.5'
      
    end
  end

end