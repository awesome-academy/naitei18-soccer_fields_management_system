class ReviewsController < ApplicationController
  before_action :load_football_pitch, only: %i(create)

  def create
    @review = current_user.reviews.build review_params
    @review.save
    respond_to(&:js)
  end

  private

  def review_params
    params.require(:review)
          .permit :rating, :comment, :football_pitch_id
  end

  def load_football_pitch
    @football_pitch = FootballPitch.find_by id: params[:football_pitch_id]

    return if @football_pitch

    flash[:danger] = t "flash.football_pitch_not_found"
    redirect_to root_url
  end
end
