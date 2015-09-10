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
     content = remove_blank_lines(content)
     content = load_image_lazy(content)
     fix_wp_content_image(content)
  end

  def load_image_lazy(content)
    content.gsub(/<img.*?>/) { |match| match.gsub('src', 'data-lazyload') }
  end

  def fix_wp_content_image(content)
    content.gsub('http://36kr.com/wp-content/uploads/', 'http://static.36kr.com/wp-content/uploads/').auto_space!
  end

  def sanitize_tags(text)
    text = text.gsub(/<title>.+?<\/title>/, "")
    tags = %w(a p br hr i em u strong iframe embed blockquote img h1 h2 h3 h4 h5 ul li ol)
    attributes = %w(href ref target src title alt width height frameborder allowfullscreen)
    remove_blank_lines sanitize(text, tags: tags, attributes: attributes)
  end

  def bdnews_sanitize_tags(text)
    content = remove_blank_lines(text)
    content = sanitize(content, tags: %w(p, b, img), attributes: %w(class data-url src  data-videourl))
    content = content.gsub('src', 'data-url').gsub('fr-fin fr-dib fr-tag', 'lazy-load')
    content = content.gsub(/<img.*?">/) { |match| '</p><p class="p-image">' + match + '</p><p class="p-text">' }
    content = '<p class="p-text">' + content + '</p>'
    content.to_s.gsub('<p class="p-text"></p>', '')
  end

  def uc_sanitize_tags(text)
    content = sanitize_tags text
    content.gsub('src', 'alt_src')
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

  def do_favorite(post, current_user)
    return "doFavorite(#{post.url_code})" if current_user.present?
  end

  def post_summary_text(summary)
    strip_tags(summary).gsub(/\s/,'')
  end
end

