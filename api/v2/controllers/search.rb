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
          data = Java::Search.search params
          posts = data['data']['article'] || []
          total_count = data['data']['totalCount'] || 0
          posts_list = []
          posts.each do |post|
            ruby_post = Post.where(url_code: post['id']).first
            posts_list << {
              id: post['id'],
              title: post['title'],
              column_id: post['column_id'],
              column_name: post['column_name'],
              comments_count: ruby_post.try(:comments_count) || 0,
              cover_real_url: post['img'],
              author: {
                name: post['author']['name'],
                avatar_url: post['author']['avatar_url']
              },
              published_at: post['published_at'].to_time.iso8601,
              updated_at: post['updated_at'].to_time.iso8601
            }
          end
          {data: posts_list, post_count: total_count}
        end

        desc 'search post'
        params do
          optional :q, type: String, desc: '查询字符'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'ruby' do
          posts = Post.search(params)
          #present posts, with: Entities::Post
          posts_list = []
          posts.each do |post|
            posts_list << {
              id: post.url_code,
              title: post.title,
              column_id: post.column_id,
              column_name: post.column_name,
              comments_count: post.comments_count,
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

      end
    end
  end
end
