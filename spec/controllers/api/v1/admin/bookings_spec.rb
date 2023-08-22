require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Admin::Bookings, type: :request do
  describe "PATCH update_status_booking" do
    let(:user) {create(:user, :admin)}
    let(:booking) {create :booking}
    context "success update status booking to accepted" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/bookings/#{booking.id}/update_status", params: {status: :accepted}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "update status booking" do
        booking.reload
        expect(booking.accepted?).to eq(true)
      end
    end

    context "success update status booking to unaccepted" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/bookings/#{booking.id}/update_status", params: {status: :unaccepted}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "update status booking" do
        booking.reload
        expect(booking.unaccepted?).to eq(true)
      end
    end

    context "fail when booking found booking" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/bookings/0/update_status", params: {status: :accepted}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when booking not found"
    end

    context "fail when session has ended" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          patch "/api/v1/admin/bookings/#{booking.id}/update_status", params: {status: :accepted}, headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end

    context "fail when user is not admin" do
      let(:user) {create :user}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/bookings/#{booking.id}/update_status", params: {status: :accepted}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user is not admin"
    end
  end
end
