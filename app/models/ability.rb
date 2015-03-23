class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    unless controller_namespace == 'Admin'
      public_ability
      if user
        can :create, Comment
        can :get_comments_count, Post
      end
    end
    can :preview, Post
    send user.role.to_sym, user if user
  end

  # 读者
  def reader(user)
    # 不能进入后台
    # 可以评论
  end

  # 投稿者
  def contributor(user)
    can :read, :dashboard
    can [:read, :create], Newsflash
    can :manage, Newsflash, :user_id => user.id
    can :new, Post
  end

  # 运营
  def operator(user)
    can :read, :dashboard
    can :read, User
    can [:read, :reviewings], Post
    can :manage, HeadLine
    can :manage, Comment
  end

  # 作者
  def writer(user)
    can :read, :dashboard
    can [:read, :reviewings], Post
    can :manage, Post, :user_id => user.id
    can :manage, Newsflash
    can :read, Comment, :commentable_type => 'Post', :commentable_id => user.posts.pluck(:id)
  end

  # 编辑
  def editor(user)
    can :read, :dashboard
    can :manage, Post
    can :manage, Newsflash
    can :manage, Column
    can :manage, Comment
    can :manage, HeadLine
    can :manage, Page
  end

  # 管理员
  def admin(user)
    can :manage, :all
  end

  def public_ability
    can :read, :welcome
    can :read, [Ad, Post, Column, Page, Newsflash, User]
    can [:update_views_count, :news, :feed, :hots, :today_lastest], Post
    can [:read, :execllents], Comment
    cannot :create, Comment
  end
end
