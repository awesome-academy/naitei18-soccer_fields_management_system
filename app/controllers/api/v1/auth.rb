module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults

      helpers do
        def represent_user_with_token user
          present jwt_token: Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        end

        def handle_activation user
          if user.activated?
            represent_user_with_token user
          else
            error!({message: "The acoount is unactivated"}, 403)
          end
        end
      end

      resources :auth do
        desc "Sign in"
        params do
          requires :email
          requires :password
        end

        post "/sign_in" do
          user = User.find_by email: params[:email]
          if user&.authenticate params[:password]
            handle_activation user
          else
            error!({message: "Invalid email/password combination"}, 401)
          end
        end
      end
    end
  end
end
