class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource :comment
  load_resource :user

  def index
    if @commentable = find_commentable
      @comments = @commentable.comments.accessible_by(current_ability).order("id desc").includes(user: :krypton_authentication).page params[:page]
    else
      @comments = Comment.accessible_by(current_ability).order("id desc").includes({user: :krypton_authentication}, :commentable)
      @comments = @coments.where(user_id: @user.id) if @user
      @comments = @comments.page params[:page]
    end
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

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end
end
