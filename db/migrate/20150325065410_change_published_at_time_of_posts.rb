class ChangePublishedAtTimeOfPosts < ActiveRecord::Migration
  def change
    Post.where("published_at is null").each do |post|
      post.update_attribute(:published_at, post.created_at)
    end
  end
end
