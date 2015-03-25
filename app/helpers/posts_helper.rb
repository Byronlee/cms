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

    #doc = Nokogiri::HTML::DocumentFragment.parse(content)
    #doc.xpath('@style|.//@style').remove
    sanitize_tags(doc).to_html
  end

  def sanitize_tags(text,namespace=nil)
    text = text.gsub(/\r\n/,"").gsub(/(^(<p>&nbsp;<\/p>){1,})|((<p>&nbsp;<\/p>){1,}$)/,"")
    tags = case namespace
           when 'submitter','online','prefile'
             %w(p u s br strong em)
           when 'process'
             %w(p u s strong br del ins em)
           else
             %w(a p br hr i em strong iframe embed)
           end
    view_context.sanitize(text, tags: tags, attributes: %w(style class))
  end

end
