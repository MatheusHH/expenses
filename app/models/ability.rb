class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      if user.kind == 'client'
        can :access, :rails_admin
        can :dashboard
        can :flow_cash
        can :manage, Provider, user_id: user.id
        can :manage, Expense, user_id: user.id
        can :manage, Category, user_id: user.id 
        can :manage, Receipt, user_id: user.id
        can :manage, Description, user_id: user.id
        can :edit, User
        #ver se o cancancan pode bloquear determinado campo
      elsif user.kind == 'manager'
        can :manage, :all
      end
    end
  end
end
# Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities