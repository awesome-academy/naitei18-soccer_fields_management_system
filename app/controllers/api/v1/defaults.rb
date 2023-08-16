module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json,
                  Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params,
                                           include_missing: false)
          end

          def logger
            Rails.logger
          end

          def authenticate_user!
            token = request.headers["Jwt-Token"]
            user_id = Authentication.decode(token)["user_id"] if token
            @current_user = User.find_by id: user_id
            return if @current_user

            api_error!("You need to log in to use the app", "failure", 401,
                       {})
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from JWT::ExpiredSignature
          error!({message: "Your session has ended"}, 401)
        end
      end
    end
  end
end
