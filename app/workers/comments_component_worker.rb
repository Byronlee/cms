class CommentsComponentWorker < BaseWorker
  def perform(params,comment)
    sso_user = V1::Passport.new(params[:sso_token]).me
    unless sso_user.is_a? TrueClass or sso_user.is_a? FalseClass
      current_user = User.find_by_origin_ids sso_user['id']
      comment.update_attribute(:user, current_user)
    end
  end
end
