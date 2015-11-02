module PostsHelper
  def display_post_content(content, cover_real_url, title)
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
     content = href_add_ref_nofollow content
     content = force_image_alt_to_post_title(content, title)
     fix_wp_content_image(content)
  end

  def display_krtv_content(content,cover,title)
    youku_url = /(http:\/\/v.youku.com.*html)/im.match content #匹配去除优酷链接
    image = if cover.blank?
              cover
            else
              "<a href='#{youku_url[0]}' target='_blank'>
                <img src='#{cover}' width='740px' height='498px'>
              </a>"
            end
    content = if content.include?('<iframe')
                  content.gsub(/<iframe.*<\/iframe>/,image) #将播放器替换成图片链接
              else
                content
              end
    content = sanitize_tags(content)
    content = remove_blank_lines(content)
    content = load_image_lazy(content)
    content = href_add_ref_nofollow content
    content = force_image_alt_to_post_title(content, title)
    fix_wp_content_image(content)
  end

  def href_add_ref_nofollow content
    doc = Nokogiri::HTML.fragment(content)
    as = doc.css 'a'
    as.each do |a|
      next if /http:\/\/(www\.)?36kr\.com\/p\// =~ a.to_s
      a.set_attribute('ref', 'nofollow')
    end
    doc.to_html
  end

  def force_image_alt_to_post_title(content, title)
    doc = Nokogiri::HTML.fragment(content)
    imgs = doc.css 'img'
    imgs.each do |img|
      img.set_attribute('alt', title)
    end
    doc.to_html
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

  def html_text_only(html)
    strip_tags(html).gsub(/\s/,'')
  end

  def post_title(title)
    raw(sanitize_tags(title))
  end

  def yidian_img_src(text)
    text.gsub('src', 'alt_src')
  end
end

