# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, FootballPitch

    return if user.blank?

    can :create, Booking
    can [:read, :cancel], Booking, user: user
    can :time_booked_booking, FootballPitch

    return unless user.admin?

    can :manage, FootballPitch
    can [:read, :update_status], Booking
  end
end
