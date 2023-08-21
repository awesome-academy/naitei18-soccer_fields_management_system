require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe FootballPitchTypesController, type: :controller do
  describe "POST create" do
    let(:user) {create(:user, :admin)}
    context "success create" do
      let(:football_pitch_type_params) {attributes_for :football_pitch_type}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_type: football_pitch_type_params}
      end

      it "should have a new football pitch type" do
        expect(FootballPitchType.where(id: assigns(:football_pitch_type).id)).to exist
      end
    end

    context "fail when football pitch params invalid" do
      let(:football_pitch_type_params) {attributes_for(:football_pitch_type, width: 0)}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_type: football_pitch_type_params}
      end

      it "have errors" do
        expect(assigns(:football_pitch_type).errors.count).not_to eq(0)
      end
    end
  end
end
