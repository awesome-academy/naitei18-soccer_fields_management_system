module API
  module Entities
    class FootballPitchType < Grape::Entity
      expose :id
      expose :name
      expose :length
      expose :width
    end
  end
end
