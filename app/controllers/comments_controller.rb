class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments.order('created_at desc')
    @comments = @comments.includes(:commentable, user: [:krypton_authentication])
    render 'comments/_list'
  end

  def create
    return render :nothing => true unless current_user && params[:comment][:content].present?
    @commentable = find_commentable
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user
    comment.save

    @comments = @commentable.comments.where("id > ?", params[:current_maxid]).order('created_at desc')
      .includes(:commentable, user:[:krypton_authentication])
    render 'comments/_list', comments: @comments, commentable: @commentable, layout: false
  end

  private

  def comment_params
    params.require(:comment).permit(:content) if params[:comment]
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
  end
end
