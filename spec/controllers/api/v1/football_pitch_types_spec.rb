require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::FootballPitchTypes, type: :request do
  describe "GET index" do
    before do
      football_pitch_types = FactoryBot.create_list(:football_pitch_type, 30)
      get "/api/v1/football_pitch_types"
    end

    include_examples "should return the correct status code", 200
  end

  describe "GET show" do
    let(:football_pitch_type) {create(:football_pitch_type)}
    context "success show" do
      before do
        get "/api/v1/football_pitch_types/#{football_pitch_type.id}"
      end

      include_examples "should return the correct status code", 200

      it "should validate value of football pitch id" do
        expect_json(id: football_pitch_type.id)
      end
    end

    context "fail when not found football pitch" do
      before do
        get "/api/v1/football_pitch_types/0"
      end

      include_examples "fail when football pitch type not found"
    end
  end
end
