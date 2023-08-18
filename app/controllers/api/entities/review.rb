module API
  module Entities
    class Review < Grape::Entity
      expose :id
      expose :rating
      expose :comment
    end
  end
end
