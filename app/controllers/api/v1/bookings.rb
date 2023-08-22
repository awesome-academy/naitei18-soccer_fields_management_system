module API
  module V1
    class Bookings < Grape::API
      include API::V1::Defaults
      include API::V1::Helpers::PaginationHelper
      helpers do
        def load_booking
          @booking = Booking.find_by id: params[:id]

          return if @booking

          error!({message: "Booking not found"}, 404)
        end
      end

      before do
        authenticate_user!
      end

      resources :bookings do
        desc "GET all bookings"
        params do
          use :pagination
        end
        get "" do
          bookings = Booking.newest
          present paginate(bookings), with: API::Entities::Booking
        end

        desc "GET a booking"
        get "/:id" do
          load_booking
          present @booking, with: API::Entities::Booking
        end

        desc "PATCH cancel"
        patch "/:id/cancel" do
          load_booking
          if !@booking.accepted? && !@booking.unaccepted? && @booking.canceled!
            present message: "Cancel the booking success"
          else
            error!(
              {message: "Cancel the booking failure"}, 422
            )
          end
        end
      end
    end
  end
end
