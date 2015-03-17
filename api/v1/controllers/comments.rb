module V1
  module Controllers
    class Comments < ::V1::Base
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
          post = params[:type].classify.constantize.find params[:pid]
          @comments = post.comments
          .includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          present @comments, with: Entities::Comment
        end

        desc 'get post by page comments list'
        params do
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :page,  type: Integer, default: 1, desc: '页数'
          optional :per_page,  type: Integer, default: 30, desc: '每页记录数'
          optional :action,  type: String, default: 'down', desc: '下翻页 down 和 上翻页 up'
        end
        get ':cid/page/:pid' do
          post = params[:type].classify.constantize.find params[:pid]
          @comments = post.comments
          .where("commentable_id = :pid and created_at #{action params} :date",
            pid: post.id, date: post.comments.find(params[:cid]).created_at)
          .includes(:commentable, user:[:krypton_authentication])
          .order('created_at desc').page(params[:page]).per(params[:per_page])
          present @comments, with: Entities::Comment
        end

        desc 'create a comments'
        params do
          optional :sso_token, type: String, desc: 'sso_token'
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :content, type: String, desc: '内容'
        end
        post ':pid/new' do
          post = params[:type].classify.constantize.find params[:pid]
          @comment = post.comments.build params.slice(*KEYS)
          if @comment.save
            #CommentsComponentWorker.perform_async(params, @comment)
            CommentsComponentWorker.new.perform(params, @comment)
            present @comment, with: Entities::Comment
          else
            error!({ error: @comment.errors.full_messages }, 400)
          end
        end

      end

    end
  end
end
