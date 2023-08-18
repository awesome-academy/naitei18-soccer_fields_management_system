module API
  module Entities
    class Booking < Grape::Entity
      include API::V1::Helpers::FormatHelper

      expose :id
      expose :name
      expose :phone_number
      expose :date_booking, format_with: :date_format
      expose :start_time, format_with: :time_format
      expose :end_time, format_with: :time_format
      expose :total_cost
      expose :football_pitch_id
    end
  end
end
