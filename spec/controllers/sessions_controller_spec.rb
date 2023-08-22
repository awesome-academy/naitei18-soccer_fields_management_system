require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  describe "Post create" do
    context "login success" do
      let(:user) {create(:user, :activated)}
      before do
        post :create, params: {session: {email: user.email, password: user.password, remember_me: "1"}}
      end

      it "should update session with user_id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it_behaves_like "redirect to user page"
    end


    context "fail when user not activated" do
      let(:user) {create(:user)}
      before do
        post :create, params: {session: {email: user.email, password: user.password}}
      end
      it "show flash user not found" do
        expect(flash[:warning]).to eq(I18n.t "flash.not_activated")
      end

      it_behaves_like "redirect to home page"
    end

    context "fail when wrong information" do
      let(:user) {create(:user)}
      before do
        post :create, params: {session: {email: user.email, password: "wrong_password"}}
      end

      it "show flash invalid email password" do
        expect(flash[:danger]).to eq(I18n.t "flash.invalid_email_password_combination")
      end

      it "render login page again" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE destroy" do
    context "logout with logged in" do
      let(:user) {create(:user)}
      before do
        log_in user
        delete :destroy
      end

      it "clear session" do
        expect(session[:user_id]).to be_nil
      end

      it_behaves_like "redirect to home page"
    end

    context "logout without logged in" do
      before do
        delete :destroy
      end

      it_behaves_like "redirect to home page"
    end
  end
end
