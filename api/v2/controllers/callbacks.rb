module V2
  module Controllers
    class Callbacks < ::V2::Base

      desc 'Callbacks Feature'
      resource :callbacks do
      	desc 'get all posts list'
        get ':url_code' do
          #views_count = Redis::HashKey.new('page_views')["Post#34034#views_count"]
          post = Post.find_by_url_code params[:url_code]
          post.increase_mobile_views_count
        end

      end

    end
  end
end