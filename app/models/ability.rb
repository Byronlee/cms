class Ability
  include CanCan::Ability

  def initialize(user)
    public_ability
    send user.role.to_sym, user if user
  end

  # 读者
  def reader(user)
  end

  # 投稿者
  def contributor
  end

  # 运营
  def operator(user)
  end

  # 作者
  def writer(user)
  end

  # 编辑
  def editor
  end

  # 管理员
  def admin
    can :manage, :all
  end

  def public_ability
    can :read, :welcome
    can :read, [Ad, Post, Column, Page, Newsflash, User]
  end
end
