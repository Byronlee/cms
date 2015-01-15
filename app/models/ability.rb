class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      member(user)
    else
      anonymous(user)
    end
  end

  def member(user)
    can :read, :welcome
    can :read, :admin
    can :manage, :all
  end

  def anonymous(user)
    can :read, :welcome
    can :read, :admin    
    can :manage, :all
  end
end
