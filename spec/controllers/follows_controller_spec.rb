require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe FollowsController, type: :controller do
  describe "POST create" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success create" do
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: football_pitch.id}
      end

      it "should have a new follow" do
        expect(Follow.where(user_id: user.id, football_pitch_id: football_pitch.id)).to exist
      end
    end

    context "fail when football pitch not found" do
      before do
        log_in user
        post :create, xhr: true, params: {football_pitch_id: 0}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "DELETE destroy" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success destroy" do
      before do
        log_in user
        user.follow football_pitch
        follow = user.follows.find_by(football_pitch_id: football_pitch.id)
        delete :destroy, xhr: true, params: {id: follow.id}
      end

      it "remove follow from database" do
        expect(Follow.where(user_id: user.id, football_pitch_id: football_pitch.id)).to_not exist
      end
    end

    context "fail when follow not found" do
      before do
        log_in user
        user.follow football_pitch
        follow = user.follows.find_by(football_pitch_id: football_pitch.id)
        delete :destroy, xhr: true, params: {id: 0}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.follow_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end
end
