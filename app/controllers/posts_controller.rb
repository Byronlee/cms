class PostsController < ApplicationController
  load_resource :only => [:get_comments_count]
  authorize_resource
  skip_before_action :verify_authenticity_token, only: [:update_views_count]

  def show
    @post = Post.find_by_url_code!(params[:url_code])
    @post.increase_views_count
    @has_favorite = current_user.favorite_of? @post rescue false
    @posts_today_lastest = Post.today_lastest
  end

  def preview
    @post = Post.find_by_key(params[:key])
    @posts_today_lastest = Post.today_lastest
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

  def get_comments_count
    render :json => @post.comments_count
  end

  def feed
    @feeds = Post.published.order("published_at desc").limit(20)
  end

  def feed_bdnews
    @feeds = Post.published
            .tagged_with('bdnews')
            .includes(:column, author:[:krypton_authentication])
            .order("published_at desc").limit(30)

    response.headers['content-type'] = 'application/xml'
  end
end
