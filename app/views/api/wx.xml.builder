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
  xml.ArticleCount params[:per_page]
  xml.Articles do
    @posts.each do |post|
      xml.item do
        xml.Title do
          xml.cdata! post.title
        end
        xml.Description do
          xml.cdata! post.summary
        end
        xml.PicUrl do
          xml.cdata! post.cover_real_url
        end
        xml.Url do
          xml.cdata! post.get_access_url
        end
      end
    end
  end
end
