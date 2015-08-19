module V2
  module Controllers
    class Search < ::V2::Base

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
              column_id: post.column_id,
              column_name: post.column_name,
              comments_count: post.comments.size,
              cover_real_url: post.cover_real_url,
              author: {
                name: post.author.display_name,
                avatar_url: post.author.avatar
              },
              published_at: post.published_at.iso8601,
              updated_at: post.updated_at.iso8601
            }
          end
          {data: posts_list, post_count: posts.total_count}
        end

        desc 'search post for wx'
        params do
          optional :q, type: String, desc: '查询字符'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 5, desc: '每页记录数'
        end
        get 'wx' do
          posts = Post.search(params)
          #present posts, with: Entities::Search
          items = []
          posts.each do |post|
            items << {
              Title: "<![CDATA[#{post.title}]]>",
              Description: "<![CDATA[#{post.summary}]]>",
              PicUrl: "<![CDATA[#{post.cover_real_url}]]>",
              Url: "<![CDATA[#{post.get_access_url}]]>"
           }
          end

          { MsgType: "<![CDATA[news]]>", ArticleCount: posts.total_count,
            Articles: { item: items }
          }

        end

      end
    end
  end
end
