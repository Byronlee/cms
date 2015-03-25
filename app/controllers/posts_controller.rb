class PostsController < ApplicationController
  load_resource :only => [:get_comments_count]
  authorize_resource
  skip_before_action :verify_authenticity_token, only: [:update_views_count]

  def show
    @post = Post.find_by_url_code(params[:url_code])
    redirect_to root_path if @post.may_publish?
  end

  def preview
    @post = Post.find_by_key(params[:key])
    return redirect_to :back, :notice => '该文章已删除或不存在，不提供预览' unless @post
    if @post.try(:state) == 'reviewing'
      render :show
    else
      redirect_to :back, :notice => '该文章已发布，不提供预览'
    end
  end

  def news
    result = JSON.parse Redis::HashKey.new('posts')['new_posts']
    @posts = result["posts"] || []
    @newsflashes = result["newsflashes"] || []
    render '_news', :layout => false
  end

  def hots
    posts_data = Redis::HashKey.new('posts')['hot_posts']
    @posts = posts_data.present? ? JSON.parse(posts_data) : []
    render '_hots', :layout => false
  end

  def today_lastest
    posts_data = Redis::HashKey.new('posts')['today_lastest']
    if posts_data.present?
      hash_data = JSON.parse(posts_data)[0]
      @posts = hash_data["posts"]
      @posts_count = hash_data["posts_count"]
    else
      @posts = []
      @posts_count = 0
    end
    render '_today_lastest', :layout => false
  end

  def update_views_count
    views_count = Redis::HashKey.new('posts')["views_count_#{params[:id]}"]
    if views_count.nil?
      views_count = Post.find(params[:id]).views_count.to_i
    else
      views_count = views_count.to_i
    end
    Redis::HashKey.new('posts')["views_count_#{params[:id]}"] = views_count.next
    if(views_count.next % Settings.post_views_count_cache == 0)
      logger.info 'sync the views count from redis cache to postgres'
      # PostViewsCountComponentWorker.perform_async(params[:id])
      # PostViewsCountComponentWorker.new.perform(params[:id])
    end
    render :json => { :success => 'true' }.to_json
  end

  def get_comments_count
    render :json => @post.comments_count
  end

  def feed
    @feeds = Post.order("published_at desc").limit(20)
  end
end
