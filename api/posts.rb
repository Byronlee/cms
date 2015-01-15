module API
  class Posts < Grape::API
    # TODO 鉴权、认证、用户、类型等规则
    KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
      :must_read, :slug, :state, :draft_key, :cover]
    STATE = ['publish', 'draft', 'archive', 'login']

    resource :posts do

      # Get all posts list
      # params[:page]
      # params[:per_page]: default is 30
      # params[:state]: default(or empty) 'publish', 'draft', 'archive', 'login'
      # Example
      #   /api/v1/posts?state=&page=1&per_page=15
      get do
        @posts = Post.all.order(created_at: :desc)
        @posts = Post.where(state: params[:state]).order(created_at: :desc) if STATE.include?(params[:state])
        @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
        present @posts, with: APIEntities::Post
      end

      # Get id posts list
      # params[:page]
      # params[:per_page]: default is 30
      # params[:sym]: default('before') 'before', 'after'
      # params[:state]: default(or empty) 'publish', 'draft', 'archive', 'login'
      # Example
      #   /api/v1/posts/:id/page?sym=after&state=&page=1&per_page=15
      get ":id/page" do
        post = Post.find(params[:id])
        if post.blank?
          error!("Post not found", 404)
        else
          sym = case params[:sym]
                when 'after'
                  '>='
                when 'before'
                  '<='
                else
                  '<='
                end
          @posts = Post.where("created_at #{sym} :date", date: post.created_at).order(created_at: :desc)
          @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
        end
        present @posts, with: APIEntities::Post
      end

      # Get post detail
      # Example
      #   /api/v1/posts/:id
      get ":id" do
        @post = Post.find(params[:id])
        error!("Post not found", 404) if @post.blank?
        present @post, with: APIEntities::Post
      end

      # Post a new post
      # require authentication
      # params:
      #   title
      #   content
      #   summary
      #   title_link
      # Example Request:
      #   POST /api/v1/posts
      post do
        #authenticate!
        #TODO: 鉴权
        @post = Post.new params.slice(*KEYS)
        if @post.save
          present @post, with: APIEntities::Post
        else
          error!({ error: @post.errors.full_messages }, 400)
        end
      end

      # Edit a post
      # require authentication
      # params:
      #   title
      #   content
      #   summary
      #   title_link
      # Example Request:
      #   POST /api/v1/posts/:id
      post ":id" do
        #authenticate!
        #TODO: 鉴权
        @post = Post.find(params[:id])
        #TODO:判断修改权限
        @post.update_attributes params.slice(*KEYS)

        present @post, with: APIEntities::Post
      end

      # Delete post. Available only for admin
      #
      # Example Request:
      #   DELETE /api/v1/posts/:id
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
