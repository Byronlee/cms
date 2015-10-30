class PostsController < ApplicationController
  authorize_resource
  load_resource :only => :bdnews
  before_filter :fetch_feeds, only: [:feed, :partner_feed, :baidu_feed, :xiaozhi_feed,
                                     :chouti_feed, :uc_feed, :coop_feed]
  skip_before_filter :verify_authenticity_token, only: :article_toggle_tag

  def show
    @post = Post.find_by_url_code!(params[:url_code])
    @post.increase_views_count
    if request.xhr?
      @post = Post.published.where("published_at < ?", @post.published_at).last
      render 'posts/_content_and_comment', locals: { :post => @post }, layout: false
    else
      raise ActiveRecord::RecordNotFound unless @post.published?
    end
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

    @posts = Post.paginate(@posts, params)

    respond_to do |format|
      format.html do
        if request.xhr?
          render 'posts/_list', locals: { :posts => @posts }, layout: false
        end
      end
      format.json do
        render json: Post.posts_to_json(@posts)
      end
    end
  end

  def feed
    redirect_to feed_path unless ['rss', 'json'].include? params[:format].to_s
  end

  alias_method :uc_feed, :feed
  alias_method :baidu_feed, :feed
  alias_method :xiaozhi_feed, :feed
  alias_method :chouti_feed, :feed

  def partner_feed
    if params[:partner] == 'liebao'
      render 'partner_liebao_feed'
    else
      render 'partner_feed'
    end
  end

  def bdnews
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'bdnews', layout: false
  end

  def ucnews
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'ucnews', layout: false
  end

  def xiaozhi_news
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'xiaozhi_news', layout: false
  end

  def chouti_news
    @post = Post.published.find_by_url_code!(params[:url_code])
    render 'chouti_news', layout: false
  end

  def coop_feed
    if Settings.coop_rss.include?(params[:coop])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def coop_news
    if Settings.coop_rss.include?(params[:coop])
      @post = Post.published.find_by_url_code!(params[:url_code])
      render "posts/coop/#{params[:coop]}_news", layout: false
    else
      redirect_to root_path
    end
  end

  def feed_bdnews
    @feeds = Post.published.tagged_with('bdnews')
    @feeds = @feeds.includes(:column, author: [:krypton_authentication])
    @feeds = @feeds.order('published_at desc').limit(30)
    response.headers['content-type'] = 'application/xml'
  end

  def article_toggle_tag
    @post = Post.find(params[:post_id])
    tag_name = params[:tag_name]
    @post.tag_list.include?(tag_name) ? @post.tag_list.delete(tag_name) : @post.tag_list << tag_name
    @post.save!
    render text: params[:tag_name]
  end

  private

  def fetch_feeds
    @feeds = Post.published.includes({ author: :krypton_authentication }, :column).order('published_at desc').page(params[:page]).per(params[:per_page])
  end
end
