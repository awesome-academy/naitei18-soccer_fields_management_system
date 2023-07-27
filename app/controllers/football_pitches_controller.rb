class FootballPitchesController < ApplicationController
  before_action :logged_in_user, only: %i(new create)
  before_action :load_football_pitch, only: %i(update)
  authorize_resource

  def index
    @pagy, @football_pitches = pagy FootballPitch.newest
  end

  def new
    @football_pitch = FootballPitch.new
    @football_pitch_type = FootballPitchType.new
  end

  def show
    @football_pitch = FootballPitch.includes(:football_pitch_type)
                                   .find_by id: params[:id]

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
end
