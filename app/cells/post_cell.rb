class PostCell < Cell::Rails
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
    render
  end

  def author(args)
    @post = args[:post]
    render
  end

  def relate(args)
    @post = args[:post]
    render
  end
end
