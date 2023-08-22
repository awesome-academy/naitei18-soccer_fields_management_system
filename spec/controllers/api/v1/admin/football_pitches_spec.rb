require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Admin::FootballPitches, type: :request do
  describe "POST create" do
    let(:user) {create(:user, :admin)}
    context "success create" do
      let(:football_pitch_type) {create(:football_pitch_type)}
      let(:football_pitch_params) {attributes_for(:football_pitch, football_pitch_type_id: football_pitch_type.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitches", params: {football_pitch: football_pitch_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 201
    end

    context "fail when football pitch params invalid" do
      let(:football_pitch_params) {attributes_for :football_pitch}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitches", params: {football_pitch: football_pitch_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 400
    end

    context "fail when session has ended" do
      let(:football_pitch_type) {create(:football_pitch_type)}
      let(:football_pitch_params) {attributes_for(:football_pitch, football_pitch_type_id: football_pitch_type.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          post "/api/v1/admin/football_pitches", params: {football_pitch: football_pitch_params}, headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end

    context "fail when user is not admin" do
      let(:user) {create :user}
      let(:football_pitch_type) {create(:football_pitch_type)}
      let(:football_pitch_params) {attributes_for(:football_pitch, football_pitch_type_id: football_pitch_type.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitches", params: {football_pitch: football_pitch_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user is not admin"
    end
  end

  describe "PATCH update" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user, :admin)}
    context "update success" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/football_pitches/#{football_pitch.id}", params: {football_pitch: {price_per_hour: 200000}}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "should update price_per_hour" do
        expect_json(price_per_hour: 200000)
      end

      include_examples "should return the correct status code", 200
    end

    context "fail with invalid price per hour" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/football_pitches/#{football_pitch.id}",params: {football_pitch: {price_per_hour: nil}}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct message", "Update price per hour of football pitch failure"

      include_examples "should return the correct status code", 422
    end

    context "fail with football pitch not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/football_pitches/0", params: {football_pitch: {price_per_hour: 200000}}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when football pitch not found"
    end

    context "fail when session has ended" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          patch "/api/v1/admin/football_pitches/#{football_pitch.id}", params: {football_pitch: {price_per_hour: 200000}}, headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end

    context "fail when user is not admin" do
      let(:user) {create :user}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        patch "/api/v1/admin/football_pitches/#{football_pitch.id}", params: {football_pitch: {price_per_hour: 200000}}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user is not admin"
    end
  end

  describe "DELETE destroy" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user, :admin)}
    context "destroy success" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        delete "/api/v1/admin/football_pitches/#{football_pitch.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "remove football pitch from database" do
        expect { football_pitch.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      include_examples "should return the correct status code", 200
    end

    context "fail with football pitch not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        delete "/api/v1/admin/football_pitches/0", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when football pitch not found"
    end

    context "fail when destroy fail" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        allow_any_instance_of(FootballPitch).to receive(:destroy).and_return(false)
        delete "/api/v1/admin/football_pitches/#{football_pitch.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end
      it "should not delete the question" do
        expect(FootballPitch.where(id: football_pitch.id)).to exist
      end

      include_examples "should return the correct message", "Delete price per hour of football pitch failure"

      include_examples "should return the correct status code", 422
    end

    context "fail when check for destroy fail" do
      let!(:booking) {create(:booking,
                            football_pitch_id: football_pitch.id,
                            user_id: user.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        delete "/api/v1/admin/football_pitches/#{football_pitch.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end
      it "should not delete the question" do
        expect(FootballPitch.where(id: football_pitch.id)).to exist
      end

      include_examples "should return the correct message", "Can not delete football pitch"

      include_examples "should return the correct status code", 405
    end

    context "fail when session has ended" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          delete "/api/v1/admin/football_pitches/#{football_pitch.id}", headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end

    context "fail when user is not admin" do
      let(:user) {create :user}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        delete "/api/v1/admin/football_pitches/#{football_pitch.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user is not admin"
    end
  end
end
