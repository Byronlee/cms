xml.instruct! :xml, :version => "1.0"
xml.urlset :xmlns => "http://36kr.com/sitemap/0.9" do
  @posts.each do |post|
  	xml.url do
      xml.loc post_url post
      xml.lastmod post.published_at.strftime("%F")
      xml.changefreq 'always'
      xml.priority '0.9'
      
    end
  end

  @authors.each do |author|
  	if author.domain.present?
	  	xml.url do
	      xml.loc "http://36kr.com/posts/#{author.domain}.html"
	      xml.lastmod author.updated_at.strftime("%F")
	      xml.changefreq 'weekly'
	      xml.priority '0.5'
	      
	    end
    end
  end

  @columns.each do |column|
  	xml.url do
      xml.loc "http://36kr.com/columns/#{column.slug}.html"
      xml.lastmod column.updated_at.strftime("%F")
      xml.changefreq 'always'
      xml.priority '0.9'
      
    end
  end

  @newsflashs.each do |newsflash|
  	xml.url do
      xml.loc "http://36kr.com/clipped/#{newsflash.id}.html"
      xml.lastmod newsflash.updated_at.strftime("%F")
      xml.changefreq 'never'
      xml.priority '0.8'
      
    end
  end

end