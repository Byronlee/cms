class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    unless controller_namespace == 'Admin'
      public_ability
      can :create, Comment if user
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
    # can :read, Comment, :commentable => { :user_id => user.id }
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
     can :read, [Ad, Post, Column, Page, Newsflash, User, Comment]
     can :update_views_count, Post
     cannot :create, Comment
  end
end
