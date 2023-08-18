module API
  module V1
    module Admin
      class Bookings < Grape::API
        helpers do
          def load_booking
            @booking = Booking.find_by id: params[:id]

            return if @booking

            error!({message: "Booking not found"}, 404)
          end
        end

        before do
          authenticate_user!
          require_admin
        end

        resources :bookings do
          desc "PATCH update status"
          patch "/:id/update_status" do
            load_booking
            if params[:status].to_sym == :accepted
              @booking.accepted!
            else
              @booking.unaccepted!
            end
          end
        end
      end
    end
  end
end
