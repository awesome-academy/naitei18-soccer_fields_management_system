require "rails_helper"

RSpec.describe Booking, type: :model do
  describe ".time_format" do
    it "should format time correct" do
      result = Booking.time_format(Time.new(2015, 8, 1, 14, 35))
      expect(result).to eq("14:35")
    end
  end

  describe ".format_date" do
    it "should format time correct" do
      result = Booking.format_date(Time.new(2015, 8, 1, 14, 35))
      expect(result).to eq("01-08-2015")
    end
  end

  describe "#get_time" do
    let(:booking) {create :booking, start_time: "7:00", end_time: "8:00"}
    it "should return time correct" do
      result = booking.get_time
      expect(result).to eq("07:00 -> 08:00")
    end
  end

  describe "#send_accept_unaccept_email" do
    let(:booking) {create :booking, status: :accepted}
    it "booking should sends an a accepted email" do
      expect { booking.send_accept_unaccept_email :accepted }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
