require "rails_helper"
require "shared_examples"
require "airborne"

RSpec.describe API::V1::Users, type: :request do
  describe "GET /api/v1/users/:id" do
    let(:user) {create(:user, :activated)}
    context "success get a user" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        get "/api/v1/users/#{user.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      it "should validate value of user id" do
        expect_json(id: user.id)
      end

      include_examples "should return the correct status code", 200
    end

    context "fail when user not login" do
      before do
        get "/api/v1/users/#{user.id}"
      end

      include_examples "fail when user not login"
    end

    context "fail when user not found" do
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        get "/api/v1/users/0", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user not found"
    end

    context "fail when user can not access" do
      let(:user_another) {create(:user, :activated)}
      before do
        token_new = Authentication.encode({user_id: user.id, exp: Time.now.to_i + 4 * 3600})
        get "/api/v1/users/#{user_another.id}", headers: { "Authorization" => "Bearer #{token_new}" }
      end

      include_examples "fail when user can not access"
    end
  end

  describe "POST /api/v1/users/signup" do
    context "success create a user" do
      let(:user_params) {attributes_for :user, password_confirmation: "Nguyenthaingoc1!"}
      before do
        post "/api/v1/users/signup", params: {user: user_params}
      end

      include_examples "should return the correct message", "Please check your email to activate your account."

      include_examples "should return the correct status code", 201
    end

    context "fail when user params invaild" do
      let(:user_params) {attributes_for(:user, password_confirmation: "Nguyenthaingoc1!", name: "")}
      before do
        post "/api/v1/users/signup", params: {user: user_params}
      end

      include_examples "should return the correct message", "name can't be blank"

      include_examples "should return the correct status code", 422
    end
  end
end
