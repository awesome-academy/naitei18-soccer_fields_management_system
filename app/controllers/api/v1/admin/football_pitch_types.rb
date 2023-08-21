module API
  module V1
    module Admin
      class FootballPitchTypes < Grape::API
        include API::V1::Helpers::PaginationHelper

        before do
          authenticate_user!
          require_admin
        end

        resources :football_pitch_types do
          desc "Create a football pitch type"
          params do
            requires :football_pitch_type, type: Hash do
              requires :name, type: String
              requires :length, type: Integer
              requires :width, type: Integer
            end
          end
          post "" do
            football_pitch_type = FootballPitchType.create! permitted_params[:football_pitch_type]
            present football_pitch_type, with: API::Entities::FootballPitchType
          end
        end
      end
    end
  end
end
