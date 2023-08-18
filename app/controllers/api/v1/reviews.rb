module API
  module V1
    class Reviews < Grape::API
      include API::V1::Defaults

      helpers do
        def load_football_pitch
          @football_pitch = FootballPitch.find_by id: params[:football_pitch_id]

          return if @football_pitch

          error!({message: "Football pitch not found"}, 404)
        end

        def can_create_review?
          return if Booking.find_by(user_id: @current_user.id, football_pitch_id: @football_pitch.id)

          error!({message: "You can not create review"}, 422)
        end
      end

      before do
        authenticate_user!
        load_football_pitch
        can_create_review?
      end

      namespace "football_pitches/:football_pitch_id" do
        resources :reviews do
          desc "Create a new review"
          params do
            requires :review, type: Hash do
              requires :rating
              requires :comment
              requires :football_pitch_id
            end
          end
          post "" do
            review = @current_user.reviews.create! permitted_params[:review]
            present review, with: API::Entities::Review
          end
        end
      end
    end
  end
end
