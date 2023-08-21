module API::V1::Helpers::PaginationHelper
  extend ActiveSupport::Concern
  extend Grape::API::Helpers

  included do
    helpers do
      params :pagination do
        optional :page, type: Integer
        optional :per_page, type: Integer
      end

      def paginate collection
        return collection unless params[:page] && params[:per_page]

        collection.limit(params[:per_page])
                  .offset((params[:page] - 1) * params[:per_page])
      end
    end
  end
end
