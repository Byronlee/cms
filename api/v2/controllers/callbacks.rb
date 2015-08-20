module V2
  module Controllers
    class Callbacks < ::V2::Base

      desc 'Callbacks Feature'
      resource :callbacks do
      	desc 'get all posts list'
        get ':url_code' do
          #views_count = Redis::HashKey.new('page_views')["Post#34034#views_count"]
          post = Post.find_by_url_code params[:url_code]
          post.increase_mobile_views_count if post
        end

        desc 'get time updated posts url_code'
        params do
          optional :time,  type: Integer, default: Time.now.to_i*100, desc: '时间'
        end
        post 'posts' do
          if ((Date.today.end_of_day - Time.at(params[:time].to_i/100)) / (3600*24)) < 15
            posts = Post.select(:url_code).where(:published_at => Time.at(params[:time].to_i/100)..Date.today.end_of_day)
            posts.map(&:url_code)
          else
            { msg: '大哥，注意身体不要用力过猛哦.' }
          end  
        end

      end

    end
  end
end