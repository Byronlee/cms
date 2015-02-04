class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @comments = Comment.includes(:commentable, user:[:krypton_authentication]).unscoped.order('char_length(content) desc').page params[:page]
  end

  def set_excellent
    @comment.update_attributes(comment_params)
    redirect_to :back
  end

  def do_publish
    if @comment.may_publish?
      @comment.publish
      @comment.save
    end
    redirect_to :back
  end

  def do_reject
    if @comment.may_reject?
      @comment.reject
      @comment.save
    end
    redirect_to :back
  end

  def destroy
    @comment.destroy
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :is_excellent ) if params[:comment]
  end
end
