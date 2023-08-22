require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Admin::FootballPitchTypes, type: :request do
  describe "POST create" do
    let(:user) {create(:user, :admin)}
    context "success create" do
      let(:football_pitch_type_params) {attributes_for :football_pitch_type}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitch_types", params: {football_pitch_type: football_pitch_type_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 201
    end

    context "fail when football pitch params invalid" do
      let(:football_pitch_type_params) {attributes_for(:football_pitch_type, length: 0)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitch_types", params: {football_pitch_type: football_pitch_type_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 422
    end

    context "fail when session has ended" do
      let(:user) {create(:user, :admin)}
      let(:football_pitch_type_params) {attributes_for :football_pitch_type}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          post "/api/v1/admin/football_pitch_types", params: {football_pitch_type: football_pitch_type_params}, headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end

    context "fail when user is not admin" do
      let(:user) {create :user}
      let(:football_pitch_type_params) {attributes_for :football_pitch_type}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/admin/football_pitch_types", params: {football_pitch_type: football_pitch_type_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user is not admin"
    end
  end
end
