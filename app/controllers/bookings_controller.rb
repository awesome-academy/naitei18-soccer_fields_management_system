class BookingsController < ApplicationController
  before_action :load_football_pitch, only: %i(new create)

  def new
    @booking = Booking.new
  end

  def create
    @booking = current_user.bookings.build booking_params
    if @booking.save
      flash[:success] = t "flash.create_booking_success"
      redirect_to root_url
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
end
