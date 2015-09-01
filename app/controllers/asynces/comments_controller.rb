class Asynces::CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
    if current_user
      @comments = @comments.where("state = 'published' or user_id = ? ", current_user.id)
    else
      @comments = @comments.published
    end
    @comments = @comments.order('created_at desc')
    @comments = @comments.includes(:commentable, user: [:krypton_authentication])
    render 'list', :layout => false
  end

  def create
    @commentable = find_commentable
    if current_user.role.admin? || (current_user.can_comment? && params[:comment][:content].present?)
      @comment = @commentable.comments.build(comment_params)
      @comment.user = current_user
      current_user.update_attributes(last_comment_at: Time.now)
      @comment.save
      @comments = @commentable.comments.where("id > ?", params[:current_maxid])
                  .where("state = 'published' or user_id = ? ", current_user.id)
                  .order('created_at desc')
                  .includes(:commentable, user: [:krypton_authentication])
    else
      @comments = Comment.none
      @message = "您刚评论了，休息 #{current_user.dist_time_from_next_comment.to_i }s 再评论吧！"
    end
    render 'list', comments: @comments, commentable: @commentable, layout: false
  end

  def excellents
    comments_data = CacheClient.instance.excellent_comments
    @comments = comments_data.present? ? JSON.parse(comments_data) : []
    render 'excellents', :layout => false
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id) if params[:comment]
  end

  def find_commentable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end
end