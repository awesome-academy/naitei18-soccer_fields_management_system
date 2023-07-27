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
            numericality: {greater_than: 0}

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

  def time_booked_booking date_booking
    bookings.booking_in_date(date_booking).order("start_time ASC").select(
      :start_time, :end_time
    ).distinct
  end

  def time_booked_booking_format date_booking
    time_booked_booking(date_booking).map(&:get_time)
  end
end
