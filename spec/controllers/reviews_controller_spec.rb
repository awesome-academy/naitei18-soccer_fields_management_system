require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe ReviewsController, type: :controller do
  describe "POST create" do
    let(:user) {create :user}
    context "success create" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review, user: user, football_pitch_id: football_pitch.id)}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: football_pitch.id, review: review_params}
      end

      it "should have a new review" do
        expect(Review.where(id: assigns(:review).id)).to exist
      end
    end

    context "fail when can not create review" do
      let(:football_pitch) {create :football_pitch}
      let(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review, user: user, football_pitch_id: football_pitch.id)}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: football_pitch.id, review: review_params}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.can_not_create_review")
      end

      it_behaves_like "redirect to home page"
    end

    context "fail when football pitch params invalid" do
      let!(:football_pitch) {create :football_pitch}
      let!(:booking) {create(:booking, user: user, football_pitch: football_pitch)}
      let(:review_params) {attributes_for(:review)}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: football_pitch.id, review: review_params}
      end

      it "have errors" do
        expect(assigns(:review).errors.count).not_to eq(0)
      end
    end

    context "fail when football pitch not found" do
      let(:review_params) {attributes_for(:review)}
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: 0, review: review_params}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end
end
