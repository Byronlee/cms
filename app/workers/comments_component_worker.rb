class CommentsComponentWorker < BaseWorker
  sidekiq_options :queue => :third_party_sso, :backtrace => true

  def perform(params, comment)
    sso_user = V1::Passport.new(params[:sso_token]).me
    unless sso_user.is_a? TrueClass or sso_user.is_a? FalseClass
      user = User.find_by_origin_ids sso_user['id']
      unless user.blank?
        comment.update_attribute(:user, user)
      else
        #TODO: 创建账户
      end
    end
  end
end
