class Asynces::CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments.order('created_at desc')
    @comments = @comments.includes(:commentable, user: [:krypton_authentication])
    render 'list', :layout => false
  end

  def create
    return render :nothing => true unless current_user && params[:comment][:content].present?
    @commentable = find_commentable
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user
    comment.save
    @comments = @commentable.comments.where("id > ?", params[:current_maxid]).order('created_at desc')
    @comments = @comments.includes(:commentable, user: [:krypton_authentication])
    render 'list', comments: @comments, commentable: @commentable, layout: false
  end

  def excellents
    comments_data = CacheClient.instance.excellent_comments
    @comments = comments_data.present? ? JSON.parse(comments_data) : []
    render 'excellents', :layout => false
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
