require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe FootballPitchesController, type: :controller do
  describe "GET index" do
    before do
      get :index
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should have 15 football pitch if total > 15" do
      FactoryBot.create_list(:football_pitch, 30)
      expect(assigns[:football_pitches].length).to eq(15)
    end
  end

  describe "GET new" do
    let(:user) {create(:user, :admin)}
    before do
      log_in user
      get :new
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "render new football pitch form" do
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user)}
    context "success show" do
      before do
        get :show, params: {id: football_pitch.id}
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "render new football pitch form" do
        expect(response).to render_template(:show)
      end

      it "assign @football_pitch" do
        expect(assigns(:football_pitch)).to eq(football_pitch)
      end

      it "assign @reviews" do
        reviews = create_list(:review, 10, user: user, football_pitch: football_pitch)
        expect(assigns(:reviews)).to eq(reviews)
      end
    end

    context "fail when not found football pitch" do
      before do
        get :show, params: {id: -1}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "POST create" do
    let(:user) {create(:user, :admin)}
    context "success create" do
      let(:football_pitch_type) {create(:football_pitch_type)}
      let(:football_pitch_params) {attributes_for(:football_pitch, football_pitch_type_id: football_pitch_type.id)}
      before do
        log_in user
        post :create, params: {football_pitch: football_pitch_params}
      end

      it "redirect to football pitches page" do
        expect(response).to redirect_to football_pitches_path
      end

      it "show flash create football pitch success" do
        expect(flash[:success]).to eq(I18n.t "flash.create_football_pitch_success")
      end
    end

    context "fail when football pitch params invalid" do
      let(:football_pitch_params) {attributes_for :football_pitch}
      before do
        log_in user
        post :create, params: {football_pitch: football_pitch_params}
      end

      it "have errors" do
        expect(assigns(:football_pitch).errors.count).not_to eq(0)
      end

      it "render new page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH update" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user, :admin)}
    context "update success" do
      before do
        log_in user
        patch :update, params: {football_pitch: {price_per_hour: 200000},
                                id: football_pitch.id}
      end

      it "update price_per_hour" do
        expect(assigns(:football_pitch).price_per_hour).to eq(200000)
      end

      it "show flash update football pitch price success" do
        expect(flash[:success]).to eq(I18n.t "flash.update_football_pitch_price_success")
      end

      it "redirect to football pitch page" do
        expect(response).to redirect_to football_pitch
      end
    end

    context "fail with invalid price per hour" do
      before do
        log_in user
        patch :update, params: {football_pitch: {price_per_hour: nil},
                                id: football_pitch.id}
      end

      it "show flash update football pitch price fail" do
        expect(flash[:danger]).to eq(I18n.t "flash.update_football_pitch_price_fail")
      end

      it "redirect to football pitch page" do
        expect(response).to redirect_to football_pitch
      end
    end

    context "fail with football pitch not found" do
      before do
        log_in user
        patch :update, params: {football_pitch: {price_per_hour: 200000},
                                id: -1}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "DELETE destroy" do
    let(:football_pitch) {create(:football_pitch)}
    let(:user) {create(:user, :admin)}
    context "destroy success" do
      before do
        log_in user
        delete :destroy, params: {id: football_pitch.id}
      end

      it "remove football pitch from database" do
        expect { football_pitch.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "show flash delete football pitch price success" do
        expect(flash[:success]).to eq(I18n.t "flash.delete_football_pitch_success")
      end

      it "redirect to football pitches page" do
        expect(response).to redirect_to football_pitches_path
      end
    end

    context "fail with football pitch not found" do
      before do
        log_in user
        patch :update, params: {football_pitch: {price_per_hour: 200000},
                                id: -1}
      end

      it "show flash football pitch not found" do
        expect(flash[:danger]).to eq(I18n.t "flash.football_pitch_not_found")
      end

      it_behaves_like "redirect to home page"
    end

    context "fail when destroy fail" do
      before do
        log_in user
        allow_any_instance_of(FootballPitch).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: football_pitch.id}
      end
      it "should not delete the football pitch" do
        expect(FootballPitch.where(id: football_pitch.id)).to exist
      end

      it "show flash delete football pitch price fail" do
        expect(flash[:danger]).to eq(I18n.t "flash.delete_football_pitch_fail")
      end
    end

    context "fail when check for destroy fail" do
      let!(:booking) {create(:booking,
                            football_pitch_id: football_pitch.id,
                            user_id: user.id)}
      before do
        log_in user
        delete :destroy, params: {id: football_pitch.id}
      end
      it "should not delete the football pitch" do
        expect(FootballPitch.where(id: football_pitch.id)).to exist
      end

      it "show flash cannot delete football pitch" do
        expect(flash[:danger]).to eq(I18n.t "flash.cannot_delete_football_pitch")
      end
    end
  end

  describe "GET time_booked_booking" do
    let!(:football_pitch) {create(:football_pitch)}
    let!(:user) {create(:user, :admin)}
    let!(:booking) {create(:booking,
                          football_pitch_id: football_pitch.id,
                          user_id: user.id,
                          date_booking: "01-01-2024",
                          start_time: "7:00",
                          end_time: "8:00")}
    before do
      log_in user
      get :time_booked_booking, params: {date_booking: "01-01-2024",
                                        id: football_pitch.id}, :format => :json
    end
    it "result should be 7:00 - 8:00" do
      expect(response.body).to eq "[\"07:00 -\\u003e 08:00\"]"
    end
  end
end
