module V1
  module Controllers
    class Search < ::V1::Base

      desc 'search'
      resource :search do

        desc 'search post'
        params do
          optional :q, type: String, desc: '查询字符'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get do
          posts = Post.search(params)
          #present posts, with: Entities::Post
          posts_list = []
          posts.each do |post|
            posts_list << {
              id: post.url_code,
              title: post.title,
              node_id: post.column_id,
              node_name: post.column_name,
              feature_img: post.cover_real_url,
              created_at: post.created_at.iso8601,
              updated_at: post.updated_at.iso8601
            }
          end
          posts_list
        end

      end
    end
  end
end
