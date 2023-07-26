class FootballPitch < ApplicationRecord
  belongs_to :football_pitch_type
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many_attached :images
  scope :newest, ->{order created_at: :desc}
end
