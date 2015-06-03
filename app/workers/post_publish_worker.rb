class PostPublishWorker < BaseWorker
	sidekiq_options :queue => :"#{Settings.sidekiq_evn.namespace}_scheduler", :backtrace => true

  def perform(post_id)
    post = Post.find(post_id)
    return true if post.published? || post.will_publish_at.blank?
    return true if post.will_publish_at - Time.now > 120
    post.publish
    post.save
  end
end
