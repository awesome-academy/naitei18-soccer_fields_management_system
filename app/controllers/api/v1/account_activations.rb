module API
  module V1
    class AccountActivations < Grape::API
      include API::V1::Defaults

      helpers do
        def load_user_by_email
          @user = User.find_by email: params[:email]
          return if @user

          error!({message: "User not found"}, 404)
        end
      end

      before do
        load_user_by_email
      end

      resources :account_activations do
        desc "Acctivate account"
        params do
          requires :email, type: String
        end
        get "/:id/edit" do
          if !@user.activated? && @user.authenticated?(:activation, params[:id])
            @user.activate
            represent_user_with_token @user
          else
            error!({message: "Acctivate account failure"}, 403)
          end
        end
      end
    end
  end
end
