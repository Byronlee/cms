class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_commentable
    @comments = @commentable.comments.order('created_at desc')
      .includes(:commentable, user:[:krypton_authentication])
    #   .excellent.order('created_at asc')
    # @comments_normal_count = @commentable.comments
    #   .where(
    #     Comment.normal.or(
    #       Comment.normal_selfown(current_user ? current_user.id : 0)
    #     )
    #   ).count
    @commentable_type = @commentable.class.to_s.downcase.pluralize
    @commentable_id = @commentable.id

    render 'comments/_list', :comments => @comments, :comments_normal_count => @comments_normal_count, :commentable_type => @commentable_type, :commentable_id => @commentable_id
  end

  def normal_list
    @commentable = find_commentable
    @comments = @commentable.comments
      .includes(:commentable, user:[:krypton_authentication])
      .where(
        Comment.normal.or(
          Comment.normal_selfown(current_user ? current_user.id : 0)
        )
      ).order('created_at asc')
    @comments_normal_count = @comments.count
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

  def execllents
    comments_data = Redis::HashKey.new('comments')['excellent']
    @comments = comments_data.present? ? JSON.parse(comments_data) : [ ]
    render '_excellents', :layout => false
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
