class PostsController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def update_views_count
    views_count = Redis::HashKey.new('posts')["views_count_#{params[:id]}"]
    if views_count.nil?
      views_count = Post.find(params[:id]).views_count.to_i
    else
      views_count = views_count.to_i
    end
    Redis::HashKey.new('posts')["views_count_#{params[:id]}"] = views_count.next
    PostViewsCountComponentWorker.perform_async(params[:id])
    render :json => {:success => "true"}.to_json
  end

  def feed
    @feeds = Post.limit(20)
  end
end
