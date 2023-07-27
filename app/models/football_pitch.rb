class FootballPitch < ApplicationRecord
  belongs_to :football_pitch_type
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many_attached :images
  scope :newest, ->{order created_at: :desc}

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :location,
            presence: true,
            length: {maximum: Settings.digit.length_150}

  validates :price_per_hour,
            presence: true,
            numericality: { greater_than: 0 }

  validates :images,
            content_type: {
              in: Settings.format.images,
              message: I18n.t("errors.messages.invalid_image_format")
            },
            size: {
              less_than: Settings.digit.size_5.megabytes,
              message: I18n.t("errors.messages.invalid_image_size_html",
                              size: Settings.digit.size_5)
            }

  def display_image index, image_size
    images[index].variant resize_to_limit: image_size
  end
end
