class FootballPitchType < ApplicationRecord
  has_many :football_pitches, dependent: :destroy

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :length, :width,
            presence: true,
            numericality: { greater_than: Settings.comparison.number_0 }
end
