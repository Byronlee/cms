class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @comments = Comment.includes(:commentable).unscoped.order('char_length(content) desc').page params[:page]
  end

  def update
    @comment.update(comment_params)
    respond_with @comment, location: admin_comments_path
  end

  def create
    @comment.save
    respond_with @comment, location: admin_comments_path
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
