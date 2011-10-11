class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
  end
end

class AmosApplicationController < ActionController::Base
  def current_user
    nil
  end
end
