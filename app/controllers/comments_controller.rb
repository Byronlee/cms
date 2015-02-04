class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments.excellent
    @comments_normal_count = @commentable.comments.normal.count
    @commentable_type = @commentable.class.to_s.downcase.pluralize
    @commentable_id = @commentable.id
  end

  def normal_list
    @commentable = find_commentable
    @comments = @commentable.comments.normal
    @comments_normal_count = @comments.count
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.set_state
    @comment.save
    redirect_to :back
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