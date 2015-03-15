module V1
  module Controllers
    class Posts < ::V1::Base
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover, :user_id, :source,
        :column_id, :remark]
      STATE = ['publish', 'draft', 'archived', 'login']

      desc 'Posts Feature'
      resource :posts do

        # Get all posts list
        # params[:page]
        # params[:per_page]: default is 30
        # params[:state]: default(or empty) 'publish', 'draft', 'archived', 'login'
        # Example
        #   /api/v1/posts?state=&page=1&per_page=15
        desc 'get all posts list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
#          optional :state,  type: String, values: STATE, default: 'publish', desc: '状态'
        end
        get 'index' do
          @posts = Post.all.order(created_at: :desc)
          @posts = Post.where(state: params[:state])
            .order(created_at: :desc) if STATE.include?(params[:state])
          @posts = @posts.page(params[:page]).per(params[:per_page])
          present @posts, with: Entities::Post
        end

        # Get id posts list
        # params[:page]
        # params[:per_page]: default is 30
        # params[:action]: default('down') 'down', 'up'
        # params[:state]: default(or empty) 'publish', 'draft', 'archived', 'login'
        # Example
        #   /api/v1/posts/:id/page?action=up&state=&page=1&per_page=15
        desc 'get id posts for page list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: "下翻页 down 和 上翻页 up"
#          requires :state, type: String, values: STATE, default: 'draft', desc: '状态'
        end
        get ":id/page" do
          post = Post.find(params[:id])
          unless post.blank?
            @posts = Post.where("created_at #{action params} :date", date: post.created_at)
              .order(created_at: :desc)
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          end
          present @posts, with: Entities::Post
        end

        # Get post detail
        # Example
        #   /api/v1/posts/:id
        desc 'get post detail'
        get ":id" do
          @post = Post.find(params[:id])
          #error!("Post not found", 404) if @post.blank?
          present @post, with: Entities::Post
        end

        # Create a new post
        # require authentication
        # params:
        #   title
        #   content
        #   summary
        #   title_link
        # Example Request:
        #   POST /api/v1/posts
        desc 'create a new post'
        params do
          requires :title,    type: String,   desc: '标题'
          requires :content,  type: String,   desc: '内容'
          requires :uid,      type: Integer,  desc: '用户id'
          requires :column_id,type: Integer,  desc: '专栏id'
          optional :source,   type: String,   desc: '来源id'
          optional :cover,    type: String,   desc: '图片封面url'
          optional :remark,   type: String,   desc: '备注'
        end
        post 'new' do
          post_params = params.slice(*KEYS)
          auth = Authentication.where(uid: params[:uid].to_s).first
          unless auth.blank?
            post_params.merge!({user_id: auth.user.id})
          else
            # TODO 如果没有User，应该创建user
          end
          @post = Post.new post_params
          if @post.save
            review_url = "#{Settings.site}/p/preview/#{@post.key}.html"
            review_url = "#{Settings.site}/p/#{@post.id}.html" if auth.present? and auth.user.editable
            admin_edit_post_url = "#{Settings.site}/krypton_d29tZW5qaW5ncmFuZmFubGV6aGVtZWRpamlkZWN1b3d1/posts/#{@post.id}/edit" if auth.present? and auth.user.editable
            return {status: true, data: {key: @post.key, published_id: @post.id}, review_url: review_url, admin_edit_post_url: admin_edit_post_url}
          else
            return {status: false, msg: @post.errors.full_messages }
          end
        end

        # Update a post
        # require authentication
        # params:
        #   title
        #   content
        #   summary
        #   title_link
        # Example Request:
        #   PUT /api/v1/posts/:id
        desc 'update a post'
        params do
          requires :id, desc: '编号'
          requires :title,    type: String,   desc: '标题'
          requires :content,  type: String,   desc: '内容'
          requires :uid,      type: Integer,  desc: '用户id'
          requires :column_id,type: Integer,  desc: '专栏id'
          optional :source,   type: String,   desc: '来源id'
          optional :cover,    type: String,   desc: '图片封面url'
          optional :remark,   type: String,   desc: '备注'
        end
        patch ':id' do
          @post = Post.find(params[:id])
          @post.update_attributes params.slice(*KEYS)
          present @post, with: Entities::Post
        end

        # Delete post. Available only for admin
        #
        # Example Request:
        #   DELETE /api/v1/posts/:id
        desc 'delete post. Available only for admin'
        delete ':id' do
          post = Post.find(params[:id])
          if post
            post.destroy
          else
            not_found!
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
