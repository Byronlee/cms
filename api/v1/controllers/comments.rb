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
          .order('created_at desc')
          .page(params[:page]).per(params[:per_page])
          #@comments = post.comments
          #.includes(:commentable, user:[:krypton_authentication])
          #.where(Comment.normal.or(
          #  Comment.normal_selfown(current_user ? current_user.id : 0)
          #))
          #.order("created_at asc").page(params[:page]).per(params[:per_page])
          present @comments, with: Entities::Comment
        end

        desc 'create a comments'
        params do
          optional :sso_token, type: String, desc: 'sso_token'
          optional :type, type: String, default: 'post', desc: '多态类型'
          optional :content, type: String, desc: '内容'
        end
        post ':pid/new' do
          #@comment = CommentsComponentWorker.perform_async(params)
          @comment = CommentsComponentWorker.new.perform(params)
#=begin
          if @comment
            present @comment, with: Entities::Comment
          else
            error!({ error: @comment.errors.full_messages }, 400)
          end
#=end
        end

      end

    end
  end
end
