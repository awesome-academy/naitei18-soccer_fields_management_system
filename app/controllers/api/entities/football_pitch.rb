module API
  module Entities
    class FootballPitch < Grape::Entity
      expose :id
      expose :name
      expose :location
      expose :price_per_hour
      expose :football_pitch_type_id
    end
  end
end
