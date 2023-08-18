module API
  module Entities
    class Booking < Grape::Entity
      expose :id
      expose :name
      expose :phone_number
      expose :date_booking
      expose :start_time
      expose :end_time
      expose :total_cost
      expose :football_pitch_id
    end
  end
end
