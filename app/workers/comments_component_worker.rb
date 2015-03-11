class CommentsComponentWorker < BaseWorker
  KEYS = [:content]
  def perform(params)
    sso_user = V1::Passport.new(params[:sso_token]).me
    unless sso_user.blank?
      current_user = User.find_by_origin_ids sso_user['id']
      post = params[:type].classify.constantize.find params[:pid]
      comment = post.comments.build params.slice(*KEYS)
      comment.user = current_user
      comment.save ? comment : nil
    else
      nil
    end
  end
end
