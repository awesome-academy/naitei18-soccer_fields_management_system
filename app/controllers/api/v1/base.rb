module API
  module V1
    class Base < Grape::API
      mount V1::Auth
      mount V1::Users
      mount V1::AccountActivations
      mount V1::FootballPitches
      mount V1::FootballPitchTypes
      mount V1::Follows
      mount V1::Admin::Base
      add_swagger_documentation(
        API_version: "v1",
        hide_documentation_path: true,
        mount_path: "/API/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
