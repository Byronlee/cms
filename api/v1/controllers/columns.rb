module V1
  module Controllers
    class Columns < ::V1::Base
      KEYS = [:name, :introduce, :cover, :icon]

      desc 'Columns Feature'
      resource :columns do

        # Get all columns list
        # params[:page]
        # params[:per_page]: default is 30
        # Example
        # /api/v1/columnss?page=1&per_page=15
        desc 'Get all columns list'
        params do
          optional :page,  type: Integer, default: 1, desc: "page"
          optional :per_page,  type: Integer, default: 30, desc: "per_page"
        end
        get 'index' do
          @columns = Column.order(id: :desc).page(params[:page]).per(params[:per_page])
          present @columns, with: Entities::Column
        end

        # Get columns detail
        # params[:page]
        # params[:per_page]: default is 30
        # Example
        # /api/v1/columns/1?page=1&per_page=15
        desc 'Get Column detail'
        params do
          optional :page,  type: Integer, default: 1, desc: "page"
          optional :per_page,  type: Integer, default: 30, desc: "per_page"
        end
        get ':id' do
          @posts = Post.where("column_id = :id", id: params[:id]).page(params[:page]).per(params[:per_page])
          error!("Post not found", 404) if @posts.blank?
          present @posts, with: Entities::Post
        end


        # Get id posts list
        # params[:page]
        # params[:per_page]: default is 30
        # params[:action]: default('down') 'down', 'up'
        # params[:state]: default(or empty) 'publish', 'draft', 'archived', 'login'
        # Example
        #   /api/v1/posts/:id/page?action=up&state=&page=1&per_page=15
        desc 'Get a column posts detail'
        params do
          optional :page,  type: Integer, default: 1, desc: "Specify the page of paginated results."
          optional :per_page,  type: Integer, default: 30, desc: "Specify the page of paginated results."
          optional :action,  type: String, default: 'down', desc: "'down', 'up'"
        end
        get ":cid/page/:pid" do
          post = Post.find(params[:pid])
          action = case params[:action]
                   when 'up'
                     '>='
                   when 'down'
                     '<='
                   else
                     '<='
                   end
          @posts = Post.where("column_id = :cid and created_at #{action} :date",
                              cid: post.column_id, date: post.created_at).order(created_at: :desc)
          if @posts.blank?
            error!("Post not found", 404)
          else
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          end
          present @posts, with: Entities::Post
        end

      end
    end
  end
end
