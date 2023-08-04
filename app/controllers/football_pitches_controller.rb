class FootballPitchesController < ApplicationController
  before_action :logged_in_user, only: %i(new create)
  before_action :load_football_pitch,
                only: %i(update destroy time_booked_booking)
  before_action :check_for_destroy, only: :destroy
  authorize_resource

  def index
    @q = FootballPitch.ransack(params[:q])
    @pagy, @football_pitches = pagy @q.result.newest
  end

  def new
    @football_pitch = FootballPitch.new
  end

  def show
    @football_pitch = FootballPitch.includes(:football_pitch_type)
                                   .find_by id: params[:id]

    @pagy, @reviews = pagy @football_pitch.reviews.includes(:user)
    return if @football_pitch

    flash[:danger] = t "flash.football_pitch_not_found"
    redirect_to root_url
  end

  def create
    @football_pitch = FootballPitch.new football_pitch_params
    if @football_pitch.save
      flash[:success] = t "flash.create_football_pitch_success"
      redirect_to football_pitches_url
    else
      render :new
    end
  end

  def update
    if @football_pitch.update football_pitch_params
      flash[:success] = t "flash.update_football_pitch_price_success"
    else
      flash[:danger] = t "flash.update_football_pitch_price_fail"
    end
    redirect_to @football_pitch
  end

  def destroy
    if @football_pitch.destroy
      flash[:success] = t "flash.delete_football_pitch_success"
    else
      flash[:danger] = t "flash.delete_football_pitch_fail"
    end
    redirect_to football_pitches_path
  end

  def time_booked_booking
    result = @football_pitch.time_booked_booking_format params[:date_booking]
    respond_to do |format|
      format.json{render json: result.as_json}
    end
  end

  private

  def load_football_pitch
    @football_pitch = FootballPitch.find_by id: params[:id]

    return if @football_pitch

    flash[:danger] = t "flash.football_pitch_not_found"
    redirect_to root_url
  end

  def football_pitch_params
    params.require(:football_pitch)
          .permit :name, :location, :price_per_hour,
                  :football_pitch_type_id, images: []
  end

  def have_booking_pending?
    @football_pitch.bookings.booking_status(:pending).empty?
  end

  def have_booking_in_future_and_accepted?
    @football_pitch.bookings.booking_future_and_accepted.empty?
  end

  def check_for_destroy
    return if have_booking_pending? && have_booking_in_future_and_accepted?

    flash[:danger] = t "flash.cannot_delete_football_pitch"
    redirect_to football_pitches_path
  end
end
