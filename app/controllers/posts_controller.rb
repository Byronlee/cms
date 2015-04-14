class PostsController < ApplicationController
  authorize_resource
  skip_before_action :verify_authenticity_token, only: [:update_views_count]

  def show
    @post = Post.find_by_url_code!(params[:url_code])
    @post.increase_views_count
  end

  def preview
    @post = Post.find_by_key!(params[:key])
    return redirect_to post_show_by_url_code_url(@post.url_code) if @post.published?
    render :show
  end

  def feed
    @feeds = Post.published.order('published_at desc').limit(20)
    respond_to :rss
  end

  def feed_bdnews
    @feeds = Post.published.tagged_with('bdnews')
    @feeds = @feeds.includes(:column, author: [:krypton_authentication])
    @feeds = @feeds.order('published_at desc').limit(30)
    response.headers['content-type'] = 'application/xml'
  end
end
