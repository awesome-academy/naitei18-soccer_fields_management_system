require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Reviews, type: :request do
  describe "POST create" do
    let(:user) {create :user}
    context "success create" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review, football_pitch_id: football_pitch.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/#{football_pitch.id}/reviews", params: {review: review_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 201

      it "should have a new review" do
        expect(Review.where(user_id: user.id, football_pitch_id: football_pitch.id)).to exist
      end
    end

    context "fail when can not create" do
      let!(:football_pitch) {create :football_pitch}
      let(:review_params) {attributes_for(:review, football_pitch_id: football_pitch.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/#{football_pitch.id}/reviews", params: {review: review_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 422

      include_examples "should return the correct message", "You can not create review"
    end

    context "fail when football pitch params invalid" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/#{football_pitch.id}/reviews", params: {review: review_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 400
    end

    context "fail when football pitch not found" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/football_pitches/0/reviews", params: {review: review_params}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when football pitch not found"
    end

    context "fail when session has ended" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review, football_pitch_id: football_pitch.id)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        Timecop.freeze(5.hours.after) do
          post "/api/v1/football_pitches/#{football_pitch.id}/reviews", params: {review: review_params}, headers: { "Authorization" => "Bearer #{token_new}" }
        end
      end

      include_examples "fail when session has ended"
    end
  end
end
