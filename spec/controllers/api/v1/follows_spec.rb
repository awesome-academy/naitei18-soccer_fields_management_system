require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Follows, type: :request do
  describe "POST create" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success create" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/follows", params: {football_pitch_id: football_pitch.id}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "should return the correct status code", 201

      include_examples "should return the correct message", "Follow the football pitch success"

      it "should have a new follow" do
        expect(Follow.where(user_id: user.id, football_pitch_id: football_pitch.id)).to exist
      end
    end

    context "fail when football pitch not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        post "/api/v1/follows", params: {football_pitch_id: 0}, headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when football pitch not found"
    end
  end

  describe "DELETE destroy" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success destroy" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        user.follow football_pitch
        follow = user.follows.find_by(football_pitch_id: football_pitch.id)
        delete "/api/v1/follows/#{follow.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "remove follow from database" do
        expect(Follow.where(user_id: user.id, football_pitch_id: football_pitch.id)).to_not exist
      end
    end

    context "fail when follow not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        user.follow football_pitch
        follow = user.follows.find_by(football_pitch_id: football_pitch.id)
        delete "/api/v1/follows/0", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when follow not found"
    end
  end
end
