class CommentsComponentWorker < BaseWorker
  KEYS = [:content]
  def perform(params,comment)
    sso_user = V1::Passport.new(params[:sso_token]).me
    unless sso_user.blank?
      current_user = User.find_by_origin_ids sso_user['id']
      comment.update_attribute(:user, current_user)
#      post = params[:type].classify.constantize.find params[:pid]
#      comment = post.comments.build params.slice(*KEYS)
      #comment.user = current_user
      #comment.save
    end
  end
end
