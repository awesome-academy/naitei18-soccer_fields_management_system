module API
  module V1
    class Base < Grape::API
      mount V1::Auth
      add_swagger_documentation(
        API_version: "v1",
        hide_documentation_path: true,
        mount_path: "/API/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
