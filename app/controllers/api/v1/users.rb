module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      helpers do
        def load_user_by_id
          @user = User.find_by id: params[:id]
          return if @user

          error!({message: "User not found"}, 404)
        end
      end

      resources :users do
        desc "Return a user"
        params do
          requires :id, type: String
        end
        get ":id", root: "user" do
          authenticate_user!
          load_user_by_id
          if @current_user.id == @user.id
            present @user, with: API::Entities::User
          else
            error!({message: "Access denied"}, 403)
          end
        end

        desc "Create a user"
        params do
          requires :user, type: Hash do
            requires :name, type: String
            requires :email, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
          end
        end

        post "/signup" do
          @user = User.create! permitted_params[:user]
          @user.send_activation_email
          present message: "Please check your email to activate your account."
        end
      end
    end
  end
end
