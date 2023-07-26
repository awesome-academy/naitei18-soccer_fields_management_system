class FootballPitch < ApplicationRecord
  belongs_to :football_pitch_type
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many_attached :images
  scope :newest, ->{order created_at: :desc}

  def display_image index, image_size
    images[index].variant resize_to_limit: image_size
  end
end
