module PostsHelper
  def display_post_content(content, cover_real_url)
    return content if cover_real_url.blank?
    content_arr = content.gsub("\r\n", "\n").split("\n\n")
    return content unless content_arr.first.include? cover_real_url
    content_arr[1..-1].join("\n\n")
  end
end
