require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Bookings, type: :request do
  describe "GET index" do
    let(:user) {create :user}
    before do
      FactoryBot.create_list(:booking, 30)
      token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
      get "/api/v1/bookings", headers: { "Authorization" => "Bearer #{token_new}" }
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    let(:user) {create(:user)}
    let(:booking) {create(:booking, user: user)}
    context "success show" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        get "/api/v1/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 200

      it "should validate value of booking id" do
        expect_json(id: booking.id)
      end
    end

    context "fail when not found booking" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        get "/api/v1/bookings/0", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when booking not found"
    end
  end

  describe "PATCH cancel_booking" do
    let(:user) {create :user}
    let(:booking) {create :booking, user: user}
    context "success cancel booking" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/bookings/#{booking.id}/cancel", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct message", "Cancel the booking success"

      it "update status booking" do
        booking.reload
        expect(booking.canceled?).to eq(true)
      end
    end

    context "fail when booking not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/bookings/0/cancel", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when booking not found"
    end

    context "fail when booking status booking is accepted or unaccepted" do
      let(:booking) {create :booking, user: user, status: :accepted}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/bookings/#{booking.id}/cancel", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 422

      include_examples "should return the correct message", "Cancel the booking failure"
    end
  end
end
