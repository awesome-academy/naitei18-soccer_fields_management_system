class FootballPitchesController < ApplicationController
  before_action :logged_in_user, only: %i(new create)
  authorize_resource

  def index
    @pagy, @football_pitches = pagy FootballPitch.newest
  end

  def new
    @football_pitch = FootballPitch.new
    @football_pitch_type = FootballPitchType.new
  end

  def show
    @football_pitch = FootballPitch.find(params[:id])
    football_pitch_type_id = @football_pitch.football_pitch_type_id
    @football_pitch_type = FootballPitchType.find football_pitch_type_id

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
      flash[:danger] = t "flash.create_football_pitch_fail"
      render :new
    end
  end

  private

  def football_pitch_params
    params.require(:football_pitch)
          .permit :name, :location, :price_per_hour,
                  :football_pitch_type_id, images: []
  end
end
