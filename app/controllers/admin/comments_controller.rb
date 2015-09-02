class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource :comment
  load_resource :user

  def index
    return commentable if find_commentable
    @q = Comment.ransack(params[:q])
    @comments = @q.result.accessible_by(current_ability).order("id desc").includes({ user: :krypton_authentication }, :commentable)
    @comments = @coments.where(user_id: @user.id) if @user
    @comments = @comments.page(params[:page]).per(params[:page_size])
  end

  def commentable
    @comments = find_commentable.comments.accessible_by(current_ability).order("id desc").includes(user: :krypton_authentication)
    @q = @comments.ransack(params[:q])
    @comments = @q.result.page params[:page]
    render :index
  end

  def set_excellent
    @comment.update_attributes(comment_params)
    redirect_to :back
  end

  def do_publish
    return redirect_to :back unless @comment.may_publish?
    @comment.publish
    @comment.save
    redirect_to :back
  end

  def do_reject
    return redirect_to :back unless @comment.may_reject?
    @comment.reject
    @comment.save
    redirect_to :back
  end

  def undo_publish
    return redirect_to :back unless @comment.may_undo_publish?
    @comment.undo_publish
    @comment.save
    redirect_to :back
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def batch_do_publish
    Comment.transaction do
      Comment.where(id: params[:ids]).each do |comment|
        next unless comment.may_publish?
        comment.publish
        comment.save
      end
    end
    render json: {result: 'success'}.to_json
  end

  def batch_undo_publish
    Comment.transaction do
      Comment.where(id: params[:ids]).each do |comment|
        next unless comment.may_undo_publish?
        comment.undo_publish
        comment.save
      end
    end
    render json: {result: 'success'}.to_json
  end

  def batch_do_reject
    Comment.transaction do
      Comment.where(id: params[:ids]).each do |comment|
        next unless comment.may_reject?
        comment.reject
        comment.save
      end
    end
    render json: {result: 'success'}.to_json
  end

  def batch_destroy
    Comment.where(id: params[:ids]).delete_all
    render json: {result: 'success'}.to_json
  end

  def batch_set_excellent
    Comment.where(id: params[:ids]).update_all({is_excellent: true})
    render json: {result: 'success'}.to_json
  end

  def batch_unset_excellent
    Comment.where(id: params[:ids]).update_all({is_excellent: false})
    render json: {result: 'success'}.to_json
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :is_excellent) if params[:comment]
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end
end
