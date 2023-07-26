# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, FootballPitch

    return unless user.admin?

    can :manage, :all
  end
end
