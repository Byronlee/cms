class CommentCell < Cell::Rails
  helper ApplicationHelper
  include CanCan::ControllerAdditions
  delegate :current_ability, to: :controller

  def index(args)
    @post = args[:post]
    render
  end

  def new(args)
    @post = args[:post]
    @current_user = args[:current_user]
    render
  end
end
