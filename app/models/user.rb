class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :football_pitches, through: :bookings
end
