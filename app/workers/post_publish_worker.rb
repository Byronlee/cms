class PostPublishWorker < BaseWorker
  def perform(post_id)
    post = Post.find(post_id)
    return true if post.published? || post.will_publish_at.blank? || Time.parse(post.will_publish_at).past?
    return true if Time.parse(post.will_publish_at) - Time.now > 120
    post.publish
    post.save
  end
end
