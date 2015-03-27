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
    render
  end

  def author(args)
    @user = args[:post].author
    render
  end

  def relate(args)
    @post = args[:post]
    render
  end

  def ad
    render
  end
end
