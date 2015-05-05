module V1
  module Controllers
    class UC < ::V1::Base
      format :json
      prefix ''
      version 'v1', using: :header, vendor: '', cacade: false

      COLUMNS = ['cn-news', 'breaking', 'us-startups', 'cn-startups', 'column']

      resource :uc_news do
        desc 'Get news list for uc'
        #example
        #  /uc_news?catId=breaking&count=10
        get do
          return { success: false, msg: '该分类不存在，请检查！' } unless COLUMNS.include? params[:catId]
          return { success: false, msg: '新闻数据限制在1~100，请检查！' } unless (1..100).include? params[:count].to_i
          posts = Post.all.order(created_at: :desc).limit(params[:count])

          cache(key: "api:v1:uc_news", etag: Time.now, expires_in: Settings.api.expires_in) do
            news = []
            posts.each do |post|
              news << {
                title: post.title,
                link: URI.encode("#{Settings.site}/p/#{post.url_code}.html"),
                summary: post.summary.to_s[0..39],
                  commentCount: post.comments_count,
                  imgUrl: URI.encode(post.cover_real_url),
                  #extraImgUrls: [],
                  #tag: ''
              }
            end

            {
              success: true,
              data: news
            }
          end
        end
      end
    end
  end
end
