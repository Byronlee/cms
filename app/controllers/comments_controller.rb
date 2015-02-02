class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def create
    @comment.save
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:content) if params[:comment]
  end
end