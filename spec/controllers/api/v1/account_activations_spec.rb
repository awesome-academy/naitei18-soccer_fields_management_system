require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::AccountActivations, type: :request do
  describe "GET edit" do
    let(:user) {create(:user)}

    context "success activate account" do
      before do
        get "/api/v1/account_activations/#{user.activation_token}/edit", params: {email: user.email}
        user.reload
      end

      it "activated should true" do
        expect(user.activated).to be_truthy
      end

      it "activated_at should not nil" do
        expect(user.activated_at).not_to be_nil
      end

      it "should return correct jwt token" do
        expect(Authentication.decode(json_body[:jwt_token])["user_id"]).to eq user.id
      end
    end

    context "fail when user not found" do
      before do
        get "/api/v1/account_activations/#{user.activation_token}/edit", params: {email: "not_found_email@gmail.com"}
      end

      include_examples "fail when user not found"
    end

    context "fail when authenticated fail" do
      before do
        get "/api/v1/account_activations/not_is_activation_token/edit", params: {email: user.email}
        user.reload
      end

      it "activated should flase" do
        expect(user.activated).to be_falsey
      end

      it "activated_at should nil" do
        expect(user.activated_at).to be_nil
      end

      include_examples "should return the correct message", "Acctivate account failure"

      include_examples "should return the correct status code", 403
    end
  end
end
