class FootballPitchType < ApplicationRecord
  has_many :football_pitches, dependent: :destroy
end
