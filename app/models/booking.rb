class Booking < ApplicationRecord
  after_update ->{send_accept_unaccept_email "accepted"},
               if: proc{|obj| obj.status == "accepted"}
  after_update ->{send_accept_unaccept_email "unaccepted"},
               if: proc{|obj| obj.status == "unaccepted"}

  belongs_to :user
  belongs_to :football_pitch

  enum status: {pending: 0, accepted: 1, unaccepted: 2, canceled: 3}

  scope :booking_in_date, lambda {|date_booking|
    where(date_booking: date_booking)
  }

  scope :booking_status, ->(status){where(status: status)}

  scope :booking_future_and_accepted,
        ->{booking_status(:accepted).where(date_booking: (Time.zone.now)..)}

  scope :newest, ->{order created_at: :desc}

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :phone_number,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :date_booking, :start_time, :end_time, :total_cost,
            presence: true

  validate :end_time_must_be_1_hour_greater_than_start_time,
           :the_booking_time_cannot_coincide_with_another_booking_time,
           unless: ->{start_time.blank? || end_time.blank?},
           on: :create

  def self.ransackable_attributes _auth_object = nil
    %w(date_booking status)
  end

  class << self
    def time_format time
      time.strftime(Settings.format.time)
    end

    def format_date date
      date.strftime(Settings.format.date)
    end
  end

  def get_time
    "#{Booking.time_format start_time} -> #{Booking.time_format end_time}"
  end

  def send_accept_unaccept_email type
    BookingMailer.accept_unaccept(self, type).deliver_now
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
    @football_pitch.time_booked_booking(date_booking).map do |time|
      if time_booking_include_time?(time) || time_booking_coincide_time?(time)
        errors.add(:end_time, I18n.t("errors.messages.coincide_time"))
        break
      end
    end
  end
end
