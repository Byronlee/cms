class ChangePublishedAtTimeOfPosts < ActiveRecord::Migration
  def change
    Post.where("published_at is null and state = 'published'").each do |post|
      post.update_attribute(:published_at, post.created_at)
    end
  end
end
