module V2
  module Controllers
    class Comments < ::V2::Base
      KEYS = [:content]

      desc 'Comment'
      resource :comments do

        desc 'get post comments list'
        params do
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          #optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':pid' do
          post = params[:type].classify.constantize.find_by_url_code params[:pid]
          @comments = post.comments
          .includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          not_found! if @comments.blank?
          cache(key: "api:v2:comments:#{params[:pid]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @comments, with: Entities::Comment
          end
        end

        desc 'get post by page comments list'
        params do
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':cid/page/:pid' do
          post = params[:type].classify.constantize.find_by_url_code params[:pid]
          not_found! if post.blank?
          @comments = post.comments
          .where("commentable_id = :pid and created_at #{action params} :date",
            pid: post.id, date: post.comments.find(params[:cid]).created_at)
          .includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          cache(key: "api:v2:comments:#{params[:cid]}:page:#{params[:pid]}", etag: Time.now, expires_in: Settings.api.expires_in) do
            present @comments, with: Entities::Comment
          end
        end

        desc 'create a comments'
        params do
          #optional :authentication_token, type: String, desc: 'authentication_token'
          optional :sso_token, type: String, desc: 'sso_token'
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :content, type: String, desc: '内容'
        end
        post ':pid/new' do
          user = current_user[0]
          post = params[:type].classify.constantize.find_by_url_code params[:pid]
          @comment = post.comments.build params.slice(*KEYS)
          @comment.user = user
          if @comment.save
            #CommentsComponentWorker.perform_async(params, @comment)
            #CommentsComponentWorker.new.perform(params, @comment)
            present @comment, with: Entities::Comment
          else
            error!({ error: @comment.errors.full_messages }, 400)
          end
        end

      end

    end
  end
end
