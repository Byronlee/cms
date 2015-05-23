module SearchHelper
  def display_search_title(post, hit)
    return raw hit['highlight']['title'].first if hit['highlight']
    raw post.title
  end
end

