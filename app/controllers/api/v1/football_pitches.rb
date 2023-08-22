module API
  module V1
    class FootballPitches < Grape::API
      include API::V1::Defaults
      include API::V1::Helpers::PaginationHelper
      helpers do
        def load_football_pitch
          @football_pitch = FootballPitch.find_by id: params[:id]

          return if @football_pitch

          error!({message: "Football pitch not found"}, 404)
        end
      end

      resources :football_pitches do
        desc "GET all football pitches"
        params do
          use :pagination
        end
        get "" do
          football_pitches = FootballPitch.newest
          present paginate(football_pitches), with: API::Entities::FootballPitch
        end

        desc "GET a football pitch"
        get "/:id" do
          load_football_pitch
          present @football_pitch, with: API::Entities::FootballPitch
        end

        desc "GET time booked booking"
        params do
          requires :date_booking
        end
        get "/:id/time_booked_booking" do
          authenticate_user!
          load_football_pitch
          result = @football_pitch.time_booked_booking_format params[:date_booking]
          present result.as_json
        end

        desc "Create a new booking"
        params do
          requires :booking, type: Hash do
            requires :name
            requires :phone_number
            requires :date_booking
            requires :start_time
            requires :end_time
            requires :total_cost
            requires :football_pitch_id
          end
        end
        post ":id/bookings" do
          authenticate_user!
          load_football_pitch
          booking = @current_user.bookings.create! permitted_params[:booking]
          present booking, with: API::Entities::Booking
        end
      end
    end
  end
end
