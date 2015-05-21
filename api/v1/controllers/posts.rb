module V1
  module Controllers
    class Posts < ::V1::Base
      STATE = ['published', 'drafted', 'archived', 'login']

      ## resource :topics  ##
      desc 'Posts Feature'
      resource :topics do

        desc 'get all posts list'
        params do
          optional :state,  type: String, default: 'published', desc: '文章状态'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get do
          @posts = Post.includes(:comments, author:[:krypton_authentication])
          .where(state: params[:state]).order(published_at: :desc)
          @posts = @posts.page(params[:page]).per(params[:per_page])
          #cache(key: "api:v1:topics", etag: Time.now, expires_in: Settings.api.expires_in) do
            #present @posts, with: Entities::Post
            posts_list = []
            @posts.each do |post|
              posts_list << {
                id: post.url_code,
                title: post.title,
                feature_img: post.cover_real_url,
                excerpt: post.summary,
                created_at: post.published_at.iso8601,
                updated_at: post.updated_at.iso8601,
                replied_at: post.updated_at.iso8601,
                replies_count: post.comments_counts,
                node_id: post.column_id,
                node_name: post.column_name,
                tags: post.tag_list,
                user: post.author,
                replies: post.comments
              }
            end
            posts_list
          #end
        end

        desc 'get index posts list'
        params do
          optional :state,  type: String, default: 'published', desc: '文章状态'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          posts = Post.includes(:comments, author:[:krypton_authentication])
          .where(state: params[:state]).order(published_at: :desc)
          .page(params[:page]).per(params[:per_page])
          present posts, with: Entities::Post
        end

        desc 'export all posts list'
        params do
          optional :date,  type: String, default: '', desc: '年-月'
          optional :state,  type: String, default: 'published', desc: '文章状态'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'export' do
          posts = Post.includes(:comments, author:[:krypton_authentication])
          .where(state: params[:state]).order(published_at: :desc)
          date = params[:date]
          unless date.blank?
            ym = date.split('-')
            posts = posts.by_month(ym[1] ,year: ym[0], field: :published_at)
          end
          posts = posts.page(params[:page]).per(params[:per_page])
          posts_list = []
          posts.each do |post|
            posts_list << {
              id: post.url_code,
              title: post.title,
              views_count: post.views_count,
              author: post.author.display_name,
              published_at: post.published_at,
              comments_counts: post.comments_counts,
              column_name: post.column_name,
              url: "#{Settings.site}/p/#{post.url_code}.html"
            }
          end
          posts_list
        end

        desc 'Get feature list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'feature' do
          @head_lines = HeadLine.published.order(order_num: :desc)
          .page(params[:page]).per(params[:per_page])
          #cache(key: "api:v1:topics:feature", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @head_lines, with: Entities::HeadLine
          #end
        end

        desc 'category'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'category/:tags' do
          category = Column.find_by_slug params[:tags]
          posts = category.posts.published.order(published_at: :desc)
          .page(params[:page]).per(params[:per_page])
          #cache(key: "api:v1:topics:category:#{params[:tags]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            posts_list = []
            posts.each do |post|
              posts_list << {
                id: post.url_code,
                title: post.title,
                feature_img: post.cover_real_url,
                excerpt: post.summary,
                created_at: post.published_at.iso8601,
                updated_at: post.updated_at.iso8601,
                replied_at: post.updated_at.iso8601,
                replies_count: post.comments_counts,
                node_id: post.column_id,
                node_name: post.column_name,
                tags: post.tag_list,
                user: post.author,
                replies: post.comments
              }
            end
            posts_list
          #end
        end

        desc 'get post comments list'
        params do
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get ':id/replies' do
          #post = params[:type].classify.constantize.find_by_url_code params[:id]
          post = Post.where(url_code: params[:id]).first
          not_found! if post.blank?
          comments = post.comments.includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          replies_list = []
          comments.each do |replie|
            replies_list << {
              id: replie.id,
              topic_id: post.url_code,
              message_id: nil,
              created_at: replie.created_at.iso8601,
              updated_at: replie.updated_at.iso8601,
              body: replie.content,
              body_html: replie.content,
            }.merge(
              user: { id: replie.user.id,
                login: replie.user.name,
                name: replie.user.name,
                email: replie.user.email,
                avatar_url: replie.user.avatar
            }) if replie.user.id != 10002
          end
          #cache(key: "api:v1:topics:#{post.url_code}:replies", etag: Time.now, expires_in: Settings.api.expires_in) do
            { replies: replies_list }.merge({
              id: post.url_code,
              title: post.title,
              replied_at: comments.last.created_at.iso8601,
              replies_count: comments.size
            })
          #end
        end

        desc 'get post detail'
        get ":id" do
          post = Post.where(url_code: params[:id]).first
          not_found! if post.blank?
          #cache(key: "api:v1:topics:#{post.url_code}", etag: post.published_at, expires_in: Settings.api.expires_in) do
            present post, with: Entities::Post
          #end
        end

      end

      ## resource :posts ##
      desc 'posts news flash'
      resource :posts do

        desc 'get all news flash list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get ':year/:month' do
          news = Newsflash.includes(author:[:krypton_authentication])
          .by_month(params[:month] ,year: params[:year], field: :created_at)
          .order('created_at asc')
          .page(params[:page]).per(params[:per_page])
          news_list = []
          news.each do |new|
            news_list << {
              id: new.id,
              title: new.hash_title,
              summary: new.news_summaries,
              source_url: new.news_url,
              created_at: new.created_at.iso8601,
              updated_at: new.updated_at.iso8601
            }.merge(
              user: { id: new.user_id,
                login: new.author.name,
                name: new.author.name,
                email: new.author.email,
                avatar_url: new.author.avatar
            }
            )
          end
          news_list
        end

        desc 'get all news flash list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get ':year/:month/:day' do
          news = Newsflash.includes(author:[:krypton_authentication])
          .by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}", field: :created_at)
          .order('created_at asc')
          .page(params[:page]).per(params[:per_page])
          news_list = []
          news.each do |new|
            news_list << {
              id: new.id,
              title: new.hash_title,
              summary: new.news_summaries,
              source_url: new.news_url,
              created_at: new.created_at.iso8601,
              updated_at: new.updated_at.iso8601
            }.merge(
              user: { id: new.user_id,
                login: new.author.name,
                name: new.author.name,
                email: new.author.email,
                avatar_url: new.author.avatar
            }
            )
          end
          news_list
        end

      end

    end
  end
end
