xml.xml do
  xml.ToUserName do
    xml.cdata! params[:to_user]
  end
  xml.FromUserName  do
    xml.cdata! params[:from_user]
  end
  xml.CreateTime Time.now.to_i
  xml.MsgType  do
    xml.cdata! "news"
  end
  total_count, per_page = @posts.total_count, params[:per_page].to_i
  xml.ArticleCount total_count < per_page ? total_count : per_page
  xml.Articles do
    @posts.each_with_index do |post,i|
      xml.item do
        xml.Title do
          xml.cdata! post.title
        end
        xml.Description do
          xml.cdata! post.summary
        end
        xml.PicUrl do
          xml.cdata! i == 0 ? post.heading_cover_url : post.square_cover_url
        end
        xml.Url do
          xml.cdata! post.get_access_url
        end
      end
    end
  end
end
