class PostCell < Cell::Rails
  helper PostsHelper
  helper ApplicationHelper

  def header(args)
    @post = args[:post]
    render
  end

  def content(args)
    @post = args[:post]
    render
  end

  def share(args)
    @post = args[:post]
    @has_favorite = args[:has_favorite]
    @user = args[:user]
    render
  end

  def author(args)
    @user = args[:post].author
    render
  end

  def relate(args)
    @post = args[:post]
    @posts = @post.find_related_tags.limit(3)
    @posts = @post.author.posts.order('created_at DESC').limit(3) if @posts.blank?
    render
  end

  def ad
    render
  end
end
