class CommentCell < Cell::Rails
  def index(args)
    @post = args[:post]
    render
  end

  def new(args)
    @post = args[:post]
    render
  end
end
