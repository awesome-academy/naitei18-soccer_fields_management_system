class FollowsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_football_pitch, only: :create
  before_action :load_follow, only: :destroy

  def create
    current_user.follow @football_pitch
    respond_to(&:js)
  end

  def destroy
    @football_pitch = @follow.football_pitch
    current_user.unfollow @football_pitch
    respond_to(&:js)
  end

  private

  def load_football_pitch
    @football_pitch = FootballPitch.find_by id: params[:football_pitch_id]

    return if @football_pitch

    flash[:danger] = t "flash.football_pitch_not_found"
    redirect_to root_url
  end

  def load_follow
    @follow = Follow.find_by id: params[:id]
    return if @follow

    flash[:danger] = t "flash.follow_not_found"
    redirect_to root_url
  end
end
