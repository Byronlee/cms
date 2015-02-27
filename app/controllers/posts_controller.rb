class PostsController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def feed
    @feeds = Post.limit(20)
  end
end
