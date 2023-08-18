module API
  module V1
    module Admin
      class Base < Grape::API
        include API::V1::Defaults
        namespace :admin do
          mount FootballPitches
          mount FootballPitchTypes
          mount Bookings
        end
      end
    end
  end
end
