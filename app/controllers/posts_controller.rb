class PostsController < ApplicationController
  authorize_resource
  load_resource :only => :bdnews

  def show
    @post = Post.find_by_url_code!(params[:url_code])
    raise ActiveRecord::RecordNotFound unless @post.published?
    @post.increase_views_count
  end

  def preview
    @post = Post.find_by_key!(params[:key])
    return redirect_to post_show_by_url_code_url(@post.url_code) if @post.published?
    render :show
  end

  def archives
    @posts = Post.published.by_year(params[:year])
    @posts = @posts.by_month(params[:month], year: params[:year]) if params[:month].present?
    @posts = @posts.by_day("#{params[:year]}-#{params[:month]}-#{params[:day]}") if params[:day].present?
    @posts = @posts.order('published_at desc').includes({ author: :krypton_authentication }, :column).page params[:page]
  end

  def feed
    @feeds = Post.published.includes({ author: :krypton_authentication }, :column).order('published_at desc').limit(20)
  end
  alias_method :baidu_feed, :feed
  alias_method :xiaozhi_feed, :feed

  def bdnews
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'bdnews', layout: false
  end

  def xiaozhi_news
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'xiaozhi_news', layout: false
  end

  def feed_bdnews
    @feeds = Post.published.tagged_with('bdnews')
    @feeds = @feeds.includes(:column, author: [:krypton_authentication])
    @feeds = @feeds.order('published_at desc').limit(30)
    response.headers['content-type'] = 'application/xml'
  end
end
