module SearchHelper
  def display_search_title(post, hit)
    return raw hit['highlight']['title'].first if hit['highlight']
    raw post.title
  end

  def display_search_newsflash_title(newflash, hit)
    return raw hit['highlight']['hash_title'].first if hit['highlight']
    raw newflash.hash_title
  end

  def show_post_url url_code
  	"#{Settings.site}/p/#{url_code}.html"
  end

  def show_user_domain_url id
  	User.find(id).try(:domain)
  end

  def show_column column_id
  	Column.find(column_id).try(:slug)
  end
end

