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
    sanitize_tags(content)
  end

  def sanitize_tags(text)
    tags = %w(a p br hr i em strong iframe embed img h1 h2 h3 h4 h5)
    sanitize(text, tags: tags, attributes: %w(href ref target src title alt))
  end

end
