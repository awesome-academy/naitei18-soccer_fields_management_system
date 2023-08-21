module API
  module V1
    module Admin
      class FootballPitches < Grape::API
        include API::V1::Helpers::PaginationHelper

        before do
          authenticate_user!
          require_admin
        end

        helpers do
          def load_football_pitch
            @football_pitch = FootballPitch.find_by id: params[:id]

            return if @football_pitch

            error!({message: "Football pitch not found"}, 404)
          end

          def have_booking_pending?
            @football_pitch.bookings.pending.present?
          end

          def have_booking_in_future_and_accepted?
            @football_pitch.bookings.booking_future_and_accepted.present?
          end

          def check_for_destroy
            return unless have_booking_pending? || have_booking_in_future_and_accepted?

            error!({message: "Can not delete football pitch"}, 405)
          end
        end

        resources :football_pitches do
          desc "Create a football pitch"
          params do
            requires :football_pitch, type: Hash do
              requires :name, type: String
              requires :location, type: String
              requires :price_per_hour, type: Integer
              requires :football_pitch_type_id
              optional :images
            end
          end
          post "" do
            football_pitch = FootballPitch.create! permitted_params[:football_pitch]
            present football_pitch, with: API::Entities::FootballPitch
          end

          desc "Update price per house a football pitch"
          params do
            requires :football_pitch, type: Hash do
              requires :price_per_hour
            end
          end
          patch ":id" do
            load_football_pitch
            if @football_pitch.update permitted_params[:football_pitch]
              present @football_pitch, with: API::Entities::FootballPitch
            else
              error!(
                {message: "Update price per hour of football pitch failure"}, 422
              )
            end
          end

          desc "Delete a football pitch"
          delete ":id" do
            load_football_pitch
            check_for_destroy
            if @football_pitch.destroy
              present message: "Delete football pitch success"
            else
              error!(
                {message: "Delete price per hour of football pitch failure"}, 422
              )
            end
          end
        end
      end
    end
  end
end
