require "rails_helper"
require "shared_examples"

RSpec.describe AccountActivationsController, type: :controller do
  describe "GET edit" do
    let(:user) {create(:user)}

    context "success activate" do
      before do
        get :edit, params: {id: user.activation_token, email: user.email}
      end

      it "activated should true" do
        expect(assigns(:user).activated).to be_truthy
      end

      it "activated_at should not nil" do
        expect(assigns(:user).activated_at).not_to be_nil
      end

      it "redirect to user page" do
        expect(response).to redirect_to user
      end

      it "show flash mail activated success" do
        expect(flash[:success]).to eq(I18n.t "flash.mail_activated_success")
      end
    end

    context "fail when user not found" do
      before do
        get :edit, params: {id: user.activation_token, email: "not_found_email@gmail.com"}
      end

      it_behaves_like "show flash user not found"

      it_behaves_like "redirect to home page"
    end

    context "fail when authenticated fail" do
      before do
        get :edit, params: {id: "not_is_activation_token", email: user.email}
      end

      it "activated should flase" do
        expect(assigns(:user).activated).to be_falsey
      end

      it "activated_at should nil" do
        expect(assigns(:user).activated_at).to be_nil
      end

      it "show flash mail activated fail" do
        expect(flash[:danger]).to eq(I18n.t "flash.mail_activated_fail")
      end

      it_behaves_like "redirect to home page"
    end
  end
end
