class Review < ApplicationRecord
  belongs_to :user
  belongs_to :football_pitch

  validates :rating,
            presence: true

  validates :comment,
            presence: true,
            length: {maximum: Settings.digit.length_150}
end
