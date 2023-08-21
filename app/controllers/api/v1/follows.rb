module API
  module V1
    class Follows < Grape::API
      include API::V1::Defaults

      helpers do
        def load_football_pitch
          @football_pitch = FootballPitch.find_by id: params[:football_pitch_id]

          return if @football_pitch

          error!({message: "Football pitch not found"}, 404)
        end

        def load_follow
          @follow = Follow.find_by id: params[:id]
          return if @follow

          error!({message: "Follow not found"}, 404)
        end
      end

      before do
        authenticate_user!
      end

      resources :follows do
        desc "Create a new follow"
        params do
          requires :football_pitch_id
        end
        post "" do
          load_football_pitch
          @current_user.follow @football_pitch
          present message: "Follow the football pitch success"
        end

        desc "Destroy a follow"
        delete "/:id" do
          load_follow
          @football_pitch = @follow.football_pitch
          @current_user.unfollow @football_pitch
          present message: "Unfollow the football pitch success"
        end
      end
    end
  end
end
