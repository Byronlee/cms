module V2
  module Controllers
    class Columns < ::V2::Base
      KEYS = [:name, :introduce, :cover, :icon]

      desc 'Columns Feature'
      resource :columns do

        desc 'get all columns list'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'index' do
          @columns = Column.where('order_num > 0')
            .order(order_num: :desc)
            .page(params[:page]).per(params[:per_page])
          present @columns, with: Entities::Column
        end

        desc 'get post list for a column'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get ':id' do
          @posts = Post.where('column_id = :id', id: params[:id])
            .order(published_at: :desc)
            .page(params[:page]).per(params[:per_page])
          present @posts, with: Entities::Post
        end

        desc 'get post list by page'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':cid/page/:pid' do
          post = Post.find_by_url_code(params[:pid])
          @posts = Post.where("column_id = :cid and published_at #{action params} :date",
            cid: post.column_id, date: post.published_at).order(published_at: :desc)
          #if @posts.blank?
          #  error!("Post not found", 404)
          #else
            @posts = @posts.page(params[:page]).per(params[:per_page] || 30)
          #end
          present @posts, with: Entities::Post
        end

      end
    end
  end
end
