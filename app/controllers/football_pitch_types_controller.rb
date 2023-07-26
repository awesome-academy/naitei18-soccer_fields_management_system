class FootballPitchTypesController < ApplicationController
  before_action :logged_in_user, only: :create
  authorize_resource

  def create
    @football_pitch_type = FootballPitchType.new football_pitch_type_params
    if @football_pitch_type.save
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t "flash.create_football_pitch_type_fail"
      redirect_to root_url
    end
  end

  private

  def football_pitch_type_params
    params.require(:football_pitch_type)
          .permit :name, :length, :width
  end
end
