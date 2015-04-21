module PostsHelper
  def display_post_content(content, cover_real_url)
    return content if content.blank?
    content = if cover_real_url.blank?
                content
              else
                sub_str = content[0...cover_real_url.length + 300]
                unless sub_str.include? cover_real_url
                  content
                else
                  "#{sub_str.sub(/<img.*?#{cover_real_url}.*?>/, '')}#{content[(cover_real_url.length + 300)..-1]}"
                end
              end
     content = sanitize_tags(content)
     remove_blank_lines(content)
  end

  def sanitize_tags(text)
    tags = %w(a p br hr i em u strong iframe embed blockquote img h1 h2 h3 h4 h5 ul li ol)
    attributes = %w(href ref target src title alt width height frameborder allowfullscreen)
    sanitize(text, tags: tags, attributes: attributes)
  end

  def remove_blank_lines(text)
    text.to_s.gsub('<p><br></p>', '')
  end

  def onblur_title(title)
    return "#{title} | 36氪" if title.length < 14
    title[0..7] << '...' << title[(title.length - 3)..title.length] << ' | 36氪'
  end

  def display_source_urls(post)
    post.source_urls_array.map do |url|
      url_domain = get_url_domain(url)
      link_to url_domain, url if url_domain.present?
    end.compact.join("、").html_safe
  end
end
