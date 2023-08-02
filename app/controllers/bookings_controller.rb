class BookingsController < ApplicationController
  before_action :load_football_pitch, only: %i(new create)
  before_action :load_booking, only: %i(show)
  def index
    @pagy, @bookings = pagy Booking.includes(:football_pitch, :user)
                                   .accessible_by(current_ability)
                                   .newest
  end

  def new
    @booking = Booking.new
  end

  def show; end

  def create
    @booking = current_user.bookings.build booking_params
    if @booking.save
      flash[:success] = t "flash.create_booking_success"
      redirect_to bookings_path
    else
      render :new
    end
  end

  private

  def booking_params
    params.require(:booking)
          .permit :name, :phone_number, :date_booking, :start_time,
                  :end_time, :total_cost, :football_pitch_id
  end

  def load_football_pitch
    @football_pitch = FootballPitch.find_by id: params[:football_pitch_id]

    return if @football_pitch

    flash[:danger] = t "flash.football_pitch_not_found"
    redirect_to root_url
  end

  def load_booking
    @booking = Booking.includes(:football_pitch, :user).find_by id: params[:id]

    return if @booking

    flash[:danger] = t "flash.booking_not_found"
    redirect_to root_url
  end
end
