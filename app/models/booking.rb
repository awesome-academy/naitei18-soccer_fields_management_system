class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :football_pitch

  scope :booking_in_date, lambda {|date_booking|
    where(date_booking: date_booking)
  }

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :phone_number,
            presence: true,
            length: {maximum: Settings.digit.length_20}

  validates :date_booking, :start_time, :end_time, :total_cost,
            presence: true

  validate :end_time_must_be_1_hour_greater_than_start_time,
           :the_booking_time_cannot_coincide_with_another_booking_time,
           unless: ->{start_time.blank? || end_time.blank?}

  def self.time_format time
    time.strftime("%H:%M")
  end

  def get_time
    "#{Booking.time_format start_time} -> #{Booking.time_format end_time}"
  end

  private

  def end_time_must_be_1_hour_greater_than_start_time
    return unless end_time < (start_time + 1.hour)

    errors.add(:end_time,
               I18n.t("errors.messages.end_time_start_time_comparison"))
  end

  def time_booking_include_time? time
    time.start_time.between?(start_time,
                             end_time) || time.end_time.between?(start_time,
                                                                 end_time)
  end

  def time_booking_coincide_time? time
    start_time.between?(time.start_time,
                        time.end_time) || end_time.between?(time.start_time,
                                                            time.end_time)
  end

  def the_booking_time_cannot_coincide_with_another_booking_time
    @football_pitch = FootballPitch.find_by id: football_pitch_id
    if @football_pitch
      @football_pitch.time_booked_booking(date_booking).map do |time|
        if time_booking_include_time?(time) || time_booking_coincide_time?(time)
          errors.add(:end_time, I18n.t("errors.messages.coincide_time"))
          break
        end
      end
    else
      errors.add(:football_pitch_id, I18n.t("errors.messages.football_pitch_not_found"))
    end
  end
end
