module V2
  module Controllers
    class Posts < ::V2::Base
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover, :user_id, :source,
        :column_id, :remark]
      STATE = ['published', 'draft', 'archived', 'login']

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
          @posts = Post.where(state: params[:state])
            .order(created_at: :desc) if STATE.include?(params[:state])
          @posts = @posts.page(params[:page]).per(params[:per_page])
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
          #post = Post.find_by_url_code(params[:id])
          post = Post.where(url_code: params[:id]).first
          unless post.blank?
            @posts = Post.where("created_at #{action params} :date", date: post.created_at)
              .order(created_at: :desc)
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          end
          present @posts, with: Entities::Post
        end

        # Get post detail
        desc 'get post detail'
        get ":id" do
          @post = Post.find params[:id]
          #error!("Post not found", 404) if @post.blank?
          present @post, with: Entities::Post
        end

        # Get post detail
        desc 'get post detail'
        get "/krplus/:id" do
          #@post = Post.find_by_url_code(params[:id])
          @post = Post.where(url_code: params[:id]).first
          #error!("Post not found", 404) if @post.blank?
          present @post, with: Entities::Post
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
            data: { key: @post.key, published_id: @post.id, state: @post.state },
            review_url: generate_review_url(@post),
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

        # Update a post
        desc 'update a post'
        params do
          requires :id, desc: '编号'
          requires :title,     type: String,   desc: '标题'
          requires :content,   type: String,   desc: '内容'
          requires :column_id, type: Integer,  desc: '专栏id'
          requires :post_type, type: String,   desc: '草稿draft还是文章post'
          optional :source,    type: String,   desc: '来源id'
          optional :cover,     type: String,   desc: '图片封面url'
          optional :remark,    type: String,   desc: '备注'
        end
        patch ':id' do
          action = params[:post_type]
          return { status: false, msg: '所传参数不合法!' }  unless %w(draft post).include?(action)
          @post = Post.find(params[:id])
          auth = @post.author.krypton_authentication
          @post.assign_attributes(params.slice(*KEYS))
          @post = coming_out(@post, auth) if action.eql?('post') and @post.drafted?
          return { status: false, msg: @post.errors.full_messages }  unless @post.save
          return { status: true,
            data: { key: @post.key, published_id: @post.id, state: @post.state },
            review_url: generate_review_url(@post),
            admin_edit_post_url: admin_edit_post_url(@post, auth) }
        end

        # Delete post. Available only for admin
        desc 'delete post. Available only for admin'
        params do
          optional :authentication_token, type: String, desc: 'authentication_token'
        end
        delete ':id' do
          user = current_user
          #post = Post.find(params[:id])
          post = Post.where(url_code: params[:id]).first
          if user and post and post.author and (user.role == 'admin' or user.id == post.author.id)
            post.destroy
            return { status: true }
          else
            return { status: false }
          end
        end

        # use key list get post list
        desc '批量获取文章'
        params do
          requires :keys, desc: '逗号分割,例如: 6bb59157-e1f9-45c3-af14-93bc1ba6b710,0d9d97dd-7474-4a81-b960-5cb1fc2c7ce8,c58cae26-3630-4a8e-9a1a-002c3d771e00'
        end
        post 'keys' do
          unless params[:keys].blank?
            @posts = Post.where(key: params[:keys].split(','))
          else
            @posts = []
          end
          present @posts, with: Entities::Post
        end
      end
    end
  end
end
