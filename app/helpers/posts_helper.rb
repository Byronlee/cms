module PostsHelper
  def display_post_content(content, cover_real_url)
    content = if cover_real_url.blank? || content.blank?
      content
    else
      sub_str = content[0...cover_real_url.length + 300]
      unless sub_str.include? cover_real_url
        content
      else
        "#{sub_str.sub(/<img.*?#{cover_real_url}.*?>/, '')}#{content[(cover_real_url.length + 300)..-1]}"
      end
    end

    doc = Nokogiri::HTML::DocumentFragment.parse(content)
    doc.xpath('@style|.//@style').remove
    doc.to_html
  end
end
