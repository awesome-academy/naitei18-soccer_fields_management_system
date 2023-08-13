require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Auth, type: :request do
  describe "POST /api/v1/auth/sign_in" do
    context "success sign in" do
      let(:user) {create(:user, :activated)}
      before do
        post "/api/v1/auth/sign_in", params: {email: user.email, password: user.password}
      end

      it "should validate types" do
        expect_json_types(jwt_token: :string)
      end

      it "should return correct jwt token" do
        expect(Authentication.decode(json_body[:jwt_token])["user_id"]).to eq user.id
      end

      include_examples "should return the correct status code", 201
    end

    context "fail sign in when user not activated" do
      let(:user) {create(:user)}
      before do
        post "/api/v1/auth/sign_in", params: {email: user.email, password: user.password}
      end

      include_examples "should return the correct message", "The acoount is unactivated"
      include_examples "should return the correct status code", 403
    end

    context "fail when wrong information" do
      let(:user) {create(:user)}
      before do
        post "/api/v1/auth/sign_in", params: {email: user.email, password: "wrong_password"}
      end
      include_examples "should return the correct message", "Invalid email/password combination"
      include_examples "should return the correct status code", 401
    end
  end
end
