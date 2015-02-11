class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
      .includes(:commentable, user:[:krypton_authentication])
      .excellent.order("created_at asc")
    @comments_normal_count = @commentable.comments
      .where(
        Comment.normal.or(
          Comment.normal_selfown(current_user ? current_user.id : 0)
        )
      ).count
    @commentable_type = @commentable.class.to_s.downcase.pluralize
    @commentable_id = @commentable.id
  end

  def normal_list
    @commentable = find_commentable
    @comments = @commentable.comments
      .includes(:commentable, user:[:krypton_authentication])
      .where(
        Comment.normal.or(
          Comment.normal_selfown(current_user ? current_user.id : 0)
        )
      ).order("created_at asc")
    @comments_normal_count = @comments.count
  end

  def create
    @commentable = find_commentable
    binding.pry
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to :back, :flash => { :info => "创建评论成功" }
    else
      redirect_to :back, :flash => { :error => @comment.errors.messages[:content].first }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content) if params[:comment]
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end
end
