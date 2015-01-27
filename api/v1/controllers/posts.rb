module V1
  module Controllers
    class Posts < ::V1::Base
      # TODO 鉴权、认证、用户、类型等规则
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover]
      STATE = ['publish', 'draft', 'archived', 'login']

      desc 'Posts Feature'
      resource :posts do

        # Get all posts list
        # params[:page]
        # params[:per_page]: default is 30
        # params[:state]: default(or empty) 'publish', 'draft', 'archived', 'login'
        # Example
        #   /api/v1/posts?state=&page=1&per_page=15
        desc 'Get all posts list'
        params do
          optional :page,  type: Integer, default: 1, desc: "Specify the page of paginated results."
          optional :per_page,  type: Integer, default: 30, desc: "Specify the page of paginated results."
          optional :state,  type: String, values: STATE, default: 'publish', desc: "Post state"
        end
        get 'index' do
          @posts = Post.all.order(created_at: :desc)
          @posts = Post.where(state: params[:state]).order(created_at: :desc) if STATE.include?(params[:state])
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
        desc 'Get id posts list'
        params do
          optional :page,  type: Integer, default: 1, desc: "Specify the page of paginated results."
          optional :per_page,  type: Integer, default: 30, desc: "Specify the page of paginated results."
          optional :action,  type: String, default: 'down', desc: "'down', 'up'"
          requires :state, type: String, values: STATE, default: 'draft', desc: ""
        end
        get ":id/page" do
          post = Post.find(params[:id])
          if post.blank?
            error!("Post not found", 404)
          else
            action = case params[:action]
                     when 'up'
                       '>='
                     when 'down'
                       '<='
                     else
                       '<='
                     end
            @posts = Post.where("created_at #{action} :date", date: post.created_at).order(created_at: :desc)
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          end
          present @posts, with: Entities::Post
        end

        # Get post detail
        # Example
        #   /api/v1/posts/:id
        desc 'Get post detail'
        get ":id" do
          @post = Post.find(params[:id])
          error!("Post not found", 404) if @post.blank?
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
        desc 'Create a new post'
        params do
          requires :title,  type: String,   desc: ""
          requires :summary,  type: String, desc: ""
          requires :content,  type: String, desc: ""
          requires :title_link,  type: String, desc: ""
          requires :state, type: String, values: STATE, default: 'draft', desc: ""
          optional :must_read, type: Boolean, default: 'false', desc: ""
          optional :slug, type: String, desc: ""
          optional :draft_key, type: String, desc: ""
          optional :cover, type: String, desc: ""
        end
        post 'new' do
          #authenticate!
          #TODO: 鉴权
          @post = Post.new params.slice(*KEYS)
          if @post.save
            present @post, with: Entities::Post
          else
            error!({ error: @post.errors.full_messages }, 400)
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
        desc 'Update a post'
        put ":id" do
          #authenticate!
          #TODO: 鉴权
          @post = Post.find(params[:id])
          #TODO:判断修改权限
          @post.update_attributes params.slice(*KEYS)

          present @post, with: Entities::Post
        end

        # Delete post. Available only for admin
        #
        # Example Request:
        #   DELETE /api/v1/posts/:id
        desc 'Delete post. Available only for admin'
        delete ":id" do
          #authenticated_as_admin!
          #TODO: 鉴权
          post = Post.find(params[:id])
          if post
            post.destroy
          else
            not_found!
          end
        end

      end

    end
  end
end
