module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      include SessionsHelper

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json

        helpers do
          def permitted_params
            @permitted_params ||= declared(params,
                                           include_missing: false)
          end

          def logger
            Rails.logger
          end

          def authenticate_user!
            token = request.headers["Authorization"]&.split(" ")&.[](1)
            user_id = Authentication.decode(token)["user_id"] if token
            @current_user = User.find_by id: user_id
            return if @current_user

            error!({message: "You need to log in to use the app"}, 401)
          end

          def represent_user_with_token user
            present jwt_token: Authentication.encode({user_id: user.id,
                                                      exp: Time.now.to_i + 4 * 3600})
          end

          def require_admin
            return if @current_user.admin?

            error!({message: "You are not authorized to do this"}, 403)
          end
        end

        rescue_from JWT::ExpiredSignature, JWT::VerificationError do
          error!({message: "Your session has ended"}, 401)
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error!({messages: e.full_messages}, 400)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          message = e.record.errors.messages.map do |attr, msg|
            "#{attr} #{msg.join(' and ')}"
          end
          error!({message: message.join(", ")}, 422)
        end
      end
    end
  end
end
