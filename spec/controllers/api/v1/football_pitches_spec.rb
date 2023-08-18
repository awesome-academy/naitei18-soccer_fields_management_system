require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::FootballPitches, type: :request do
  describe "GET index" do
    before do
      football_pitches = FactoryBot.create_list(:football_pitch, 30)
      get "/api/v1/football_pitches", params: {per_page: 10, page: 1}
    end

    it "should return correct per_page" do
      expect(json_body.length).to eq(10)
    end

    include_examples "should return the correct status code", 200
  end

  describe "GET show" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user)}
    context "success show" do
      before do
        get "/api/v1/football_pitches/#{football_pitch.id}"
      end

      include_examples "should return the correct status code", 200

      it "should validate value of football pitch id" do
        expect_json(id: football_pitch.id)
      end
    end

    context "fail when not found football pitch" do
      before do
        get "/api/v1/football_pitches/0"
      end

      include_examples "fail when football pitch not found"
    end
  end

  describe "GET time_booked_booking" do
    let!(:football_pitch) {create(:football_pitch)}
    let!(:user) {create(:user, :admin)}
    let!(:booking) {create(:booking,
                          football_pitch_id: football_pitch.id,
                          user_id: user.id,
                          date_booking: "01-01-2024",
                          start_time: "7:00",
                          end_time: "8:00")}
    before do
      token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
      get "/api/v1/football_pitches/#{football_pitch.id}/time_booked_booking", params: {date_booking: "01-01-2024",}, headers: { "Authorization" => "Bearer #{token_new}" }
    end
    it "result should be 7:00 - 8:00" do
      expect(response.body).to eq "[\"07:00 -\\u003e 08:00\"]"
    end
  end

  describe "POST create a new booking" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success create" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/#{football_pitch.id}/bookings", params: {booking: booking_params} , headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 201
    end

    context "fail when booking params invalid" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id, date_booking: nil)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/#{football_pitch.id}/bookings", params: {booking: booking_params} , headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 422
    end

    context "fail when football pitch not found" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/0/bookings", params: {booking: booking_params} , headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when football pitch not found"
    end
  end
end
