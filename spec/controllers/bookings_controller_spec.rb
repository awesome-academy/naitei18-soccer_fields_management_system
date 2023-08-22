require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe BookingsController, type: :controller do
  describe "GET index" do
    let(:user) {create :user}
    before do
      FactoryBot.create_list(:booking, 30)
      log_in user
      get :index
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    before do
      log_in user
      get :new, params: {football_pitch_id: football_pitch.id}
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new booking form" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:user) {create(:user)}
    let(:booking) {create(:booking, user: user)}
    context "success show" do
      before do
        log_in user
        get :show, params: {id: booking.id}
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "render show football pitch form" do
        expect(response).to render_template(:show)
      end

      it "assign @booking" do
        expect(assigns(:booking)).to eq(booking)
      end
    end

    context "fail when not found booking" do
      before do
        log_in user
        get :show, params: {id: -1}
      end

      it "show flash booking not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.booking_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "POST create" do
    let(:user) {create :user}
    let(:football_pitch) {create :football_pitch}
    context "success create" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id)}
      before do
        log_in user
        post :create, params: {football_pitch_id: football_pitch.id, booking: booking_params}
      end

      it "redirect to bookings page" do
        expect(response).to redirect_to bookings_path
      end

      it "show flash create booking pitch success" do
        expect(flash[:success]).to eq(I18n.t "flash.create_booking_success")
      end
    end

    context "fail when booking params invalid" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id, date_booking: nil)}
      before do
        log_in user
        post :create, params: {football_pitch_id: football_pitch.id, booking: booking_params}
      end

      it "have errors" do
        expect(assigns(:booking).errors.count).not_to eq(0)
      end

      it "render new page" do
        expect(response).to render_template(:new)
      end
    end

    context "fail when football pitch not found" do
      let(:booking_params) {attributes_for(:booking, football_pitch_id: football_pitch.id)}
      before do
        log_in user
        post :create, params: {football_pitch_id: 0, booking: booking_params}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "PATCH update_status_booking" do
    let(:user) {create(:user, :admin)}
    let(:booking) {create :booking}
    context "success update status booking to accepted" do
      before do
        log_in user
        patch :update_status, xhr: true, params: {id: booking.id, status: :accepted}
      end

      it "update status booking" do
        expect(assigns(:booking).accepted?).to eq(true)
      end
    end

    context "success update status booking to unaccepted" do
      before do
        log_in user
        patch :update_status, xhr: true, params: {id: booking.id, status: :unaccepted}
      end

      it "update status booking" do
        expect(assigns(:booking).unaccepted?).to eq(true)
      end
    end

    context "fail when booking found booking" do
      before do
        log_in user
        patch :update_status, xhr: true, params: {id: 0, status: :accepted}
      end

      it "show flash booking not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.booking_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "PATCH cancel_booking" do
    let(:user) {create :user}
    let(:booking) {create :booking, user: user}
    context "success cancel booking" do
      before do
        log_in user
        patch :cancel, xhr: true, params: {id: booking.id}
      end

      it "update status booking" do
        expect(assigns(:booking).canceled?).to eq(true)
      end
    end

    context "fail when booking not found" do
      before do
        log_in user
        patch :cancel, xhr: true, params: {id: 0}
      end

      it "show flash booking not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.booking_not_found")
      end

      it_behaves_like "redirect to home page"
    end

    context "fail when booking status booking is accepted or unaccepted" do
      let(:booking) {create :booking, user: user, status: :accepted}
      before do
        log_in user
        patch :cancel, xhr: true, params: {id: booking.id}
      end

      it "show flash booking not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.canceled_football_pitch_fail")
      end

      it "redirect to bookings page" do
        expect(response).to redirect_to bookings_path
      end
    end
  end
end
