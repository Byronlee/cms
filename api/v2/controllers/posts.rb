module V2
  module Controllers
    class Posts < ::V2::Base
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover, :user_id, :source,
        :column_id, :remark, :tag_list]
      STATE = ['published', 'drafted', 'archived']

      desc 'Posts Feature'
      resource :posts do

        # Get all posts list
        desc 'get all posts list'
        params do
          optional :state,  type: String, default: 'published', desc: '文章状态'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          @posts = Post.includes(:related_links)# , author:[:krypton_authentication])
          .where(state: params[:state])
          .order(published_at: :desc)
          .page(params[:page]).per(params[:per_page])
          #cache(key: "api:v2:posts:index", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @posts, with: Entities::Post
          #end
        end

        # Get tag posts list
        desc 'get tags posts list'
        params do
          optional :id,  type: Integer, desc: 'url_code'
          optional :tag,  type: String, desc: '标签'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: "下翻页 down 和 上翻页 up"
        end
        get "tag/page" do
          unless params[:id].blank?
            post = Post.where(url_code: params[:id]).first
            not_found! if post.blank?
            unless post.blank?
              @posts = Post.published
              .includes(:related_links, :column)#, author: [:krypton_authentication])
              .tagged_with(params[:tag])
              .where("published_at #{action params} :date", date: post.published_at)
              .order('published_at desc')
              .page(params[:page]).per(params[:per_page])
            end
          else
              @posts = Post.published
              .includes(:related_links, :column)#, author: [:krypton_authentication])
              .tagged_with(params[:tag])
              .order('published_at desc')
              .page(params[:page]).per(params[:per_page])
          end
          present @posts, with: Entities::Post
        end

        # Get id posts list
        desc 'get id posts for page list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: "下翻页 down 和 上翻页 up"
        end
        get ":id/page" do
          post = Post.where(url_code: params[:id]).first
          not_found! if post.blank?
          unless post.blank?
            @posts = Post#.includes(author:[:krypton_authentication])
              .where("published_at #{action params} :date", date: post.published_at)
              .order(published_at: :desc)
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          end
          #cache(key: "api:v2:posts:#{params[:id]}:page:#{params[:action]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @posts, with: Entities::Post
          #end
        end

        # Get post detail
        desc 'get post detail'
        get ":id" do
          @post = Post#.includes(author:[:krypton_authentication])
          .where(url_code: params[:id]).first
          not_found! if @post.blank?
          #cache(key: "api:v2:posts:#{params[:id]}", etag: @post.published_at, expires_in: Settings.api.expires_in) do
            present @post, with: Entities::PostDetail
          #end
        end

        # Create a new post
        desc 'create a new post'
        params do
          requires :title,     type: String,   desc: '标题'
          requires :content,   type: String,   desc: '内容'
          requires :uid,       type: Integer,  desc: '用户SSO_ID'
          requires :column_id, type: Integer,  desc: '专栏id'
          requires :post_type, type: String,   desc: '草稿draft还是文章post'
          optional :source,    type: String,   desc: '来源id'
          optional :cover,     type: String,   desc: '图片封面url'
          optional :remark,    type: String,   desc: '备注'
          optional :tag_list,  type: String,   desc: 'tag'
        end
        post 'new' do
          action = params[:post_type]
          return { status: false, msg: '所传参数不合法!' }  unless %w(draft post).include?(action)
          post_params = params.slice(*KEYS)
          auth = Authentication.where(uid: params[:uid].to_s).first
          unless auth.blank?
            post_params.merge!(user_id: auth.user.id)
          else
           return { status: false, msg: '用户无效,请登录网站激活用户 !' }
          end
          @post = Post.new post_params
          @post = coming_out(@post, auth) if action.eql?('post')
          return { status: false, msg: @post.errors.full_messages }  unless @post.save
          return { status: true,
            data: { key: @post.key, published_id: @post.url_code, state: @post.state },
            review_url: generate_review_url(@post),
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

        # Update a post
        desc 'update a post'
        params do
          requires :id, desc: '编号'
          requires :title,     type: String,   desc: '标题'
          requires :content,   type: String,   desc: '内容'
          requires :uid,       type: Integer,  desc: '用户SSO_ID'
          requires :column_id, type: Integer,  desc: '专栏id'
          requires :post_type, type: String,   desc: '草稿draft还是文章post'
          optional :source,    type: String,   desc: '来源id'
          optional :cover,     type: String,   desc: '图片封面url'
          optional :remark,    type: String,   desc: '备注'
          optional :tag_list,  type: String,   desc: 'tag'
        end
        patch ':id' do
          action = params[:post_type]
          return { status: false, msg: '所传参数不合法!' }  unless %w(draft post).include?(action)
          @post = Post.find(params[:id])
          #auth = @post.author.krypton_authentication
          auth = Authentication.where(uid: params[:uid].to_s).first
          @post.assign_attributes(params.slice(*KEYS))
          @post = coming_out(@post, auth) if action.eql?('post') and @post.drafted?
          return { status: false, msg: @post.errors.full_messages }  unless @post.save
          return { status: true,
            data: { key: @post.key, published_id: @post.url_code, state: @post.state },
            review_url: generate_review_url(@post),
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

        # Delete post. Available only for admin
#        desc 'delete post. Available only for admin'
#        params do
#          optional :authentication_token, type: String, desc: 'authentication_token'
#        end
#        delete ':id' do
#          user = current_user
#          post = Post.where(url_code: params[:id]).first
#          if user and post and post.author and (user.role == 'admin' or user.id == post.author.id)
#            post.destroy
#            return { status: true }
#          else
#            return { status: false }
#          end
#        end

        # use key list get post list
        desc '批量获取文章'
        params do
          requires :keys, desc: '逗号分割,例如: xxx,ooo'
        end
        post 'keys' do
          unless params[:keys].blank?
            @posts = Post.where(key: params[:keys].split(','))
          else
            @posts = []
          end
          present @posts, with: Entities::PostDetailAll
        end
      end
    end
  end
end
