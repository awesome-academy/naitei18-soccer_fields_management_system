class BookingsController < ApplicationController
  before_action :logged_in_user
  before_action :load_football_pitch, only: %i(new create)
  before_action :load_booking, only: %i(show update_status cancel)
  authorize_resource

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

  def update_status
    if params[:status] == :accepted
      @booking.accepted!
    else
      @booking.unaccepted!
    end
    respond_to(&:js)
  end

  def cancel
    if @booking.canceled!
      respond_to do |format|
        format.js{render "update_status"}
      end
    else
      flash[:danger] = t "flash.canceled_football_pitch_fail"
      redirect_to bookings_path
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
