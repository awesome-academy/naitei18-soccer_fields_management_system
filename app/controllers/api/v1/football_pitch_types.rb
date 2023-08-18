module API
  module V1
    class FootballPitchTypes < Grape::API
      include API::V1::Defaults
      include API::V1::Helpers::PaginationHelper

      helpers do
        def load_football_pitch_type
          @football_pitch_type = FootballPitchType.find_by id: params[:id]

          return if @football_pitch_type

          error!({message: "Football pitch type not found"}, 404)
        end
      end

      resources :football_pitch_types do
        desc "GET all football pitch types"
        get "" do
          football_pitch_types = FootballPitchType.newest
          present football_pitch_types, with: API::Entities::FootballPitchType
        end

        desc "GET a football pitch type"
        get "/:id" do
          load_football_pitch_type
          present @football_pitch_type, with: API::Entities::FootballPitchType
        end
      end
    end
  end
end
