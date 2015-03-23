module PostsHelper
  def display_post_content(content, cover_real_url)
    return content if cover_real_url.blank? || content.blank?
    sub_str = content[0...cover_real_url.length + 300]
    return content unless sub_str.include? cover_real_url
    sub_str.sub(/<img.*?#{cover_real_url}.*?>/, '') + content[(cover_real_url.length + 300)..-1]
  end
end
