module V1
  module Controllers
    class Posts < ::V1::Base
      KEYS = [:id, :title, :created_at, :updated_at, :summary, :content,:title_link,
        :must_read, :slug, :state, :draft_key, :cover, :user_id, :source,
        :column_id, :remark]
      STATE = ['published', 'draft', 'archived', 'login']

      desc 'Posts Feature'
      resource :topics do

        desc 'get all posts list'
        params do
          optional :state,  type: String, default: 'published', desc: '文章状态'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
#          optional :state,  type: String, values: STATE, default: 'publish', desc: '状态'
        end
        get do
          @posts = Post.all.order(created_at: :desc)
          @posts = Post.where(state: params[:state])
            .order(created_at: :desc) if STATE.include?(params[:state])
          @posts = @posts.page(params[:page]).per(params[:per_page])
          present @posts, with: Entities::Post
        end
        get 'index' do
          @posts = Post.all.order(created_at: :desc)
          @posts = Post.where(state: params[:state])
            .order(created_at: :desc) if STATE.include?(params[:state])
          @posts = @posts.page(params[:page]).per(params[:per_page])
          present @posts, with: Entities::Post
        end
        get 'export' do
          posts = Post.all.order(created_at: :desc)
          posts = Post.where(state: params[:state])
            .order(created_at: :desc) if STATE.include?(params[:state])
          posts = posts.page(params[:page]).per(params[:per_page])
          posts_list = []
          posts.each do |post|
           posts_list << {
             id: post.url_code,
             title: post.title,
             views_count: post.views_count,
             author: post.author.name,
             published_at: post.published_at,
             comments_counts: post.comments_counts,
             column_name: post.column_name,
             url: "#{Settings.site}/p/#{post.url_code}.html"
           }
          end
          posts_list
        end

        desc 'Get feature list'
        get 'feature' do
          @head_lines = HeadLine.all.order(order_num: :desc)
            .page(params[:page]).per(params[:per_page])
          present @head_lines, with: Entities::HeadLine
        end

        desc 'category'
        params do
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
        end
        get 'category/:tags' do
          category = Column.find_by_slug params[:tags]
          posts = category.posts.published.order(created_at: :desc)
            .page(params[:page]).per(params[:per_page])
          present posts, with: Entities::Post
        end

        desc 'get post comments list'
        params do
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          #optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':id/replies' do
          #post = params[:type].classify.constantize.find_by_url_code params[:id]
          post = Post.where(url_code: params[:id]).first
          comments = post.comments.includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          #present @comments, with: Entities::Comment
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
          { replies: replies_list }.merge({
            id: post.url_code,
            title: post.title,
            replied_at: comments.last.created_at.iso8601,
            replies_count: comments.size
          })
        end

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

        desc 'get post detail'
        get ":id" do
          @post = Post.where(url_code: params[:id]).first
          #@post = Post.find(params[:id])
          #error!("Post not found", 404) if @post.blank?
          present @post, with: Entities::Post
        end

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
          post_params.merge!({user_id: auth.user.id}) unless auth.blank?
          @post = Post.new post_params
          if @post.save
            review_url = "#{Settings.site}/p/preview/#{@post.key}.html"
            if auth.present? and auth.user.editable
              #@post.update_attribute(:state, 'published')
              @post.publish
              review_url = "#{Settings.site}/p/#{@post.url_code}.html"
              admin_edit_post_url = "#{Settings.site}/krypton/posts/#{@post.id}/edit"
            end
            return {status: true, data: {key: @post.key, published_id: @post.id}, review_url: review_url, admin_edit_post_url: admin_edit_post_url}
          else
            return {status: false, msg: @post.errors.full_messages }
          end
        end

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
          user = @post.author
          if user and user.editable
            admin_edit_post_url = "#{Settings.site}/krypton/posts/#{@post.id}/edit"
          end
          if @post.published?
            review_url = "#{Settings.site}/p/#{@post.url_code}.html"
          else
            review_url = "#{Settings.site}/p/preview/#{@post.key}.html"
          end
          @post.update_attributes params.slice(*KEYS) rescue return {status: false, msg: '更新失败!' }
          return {status: true, data: {key: @post.key, published_id: @post.id}, review_url: review_url, admin_edit_post_url: admin_edit_post_url}
        end

        desc 'delete post. Available only for admin'
        params do
          optional :authentication_token, type: String, desc: 'authentication_token'
        end
        delete ':id' do
          user = current_user
          post = Post.find(params[:id])
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
