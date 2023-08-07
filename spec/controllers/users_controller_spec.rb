require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  describe "GET show" do
    let(:user) {create(:user)}
    context "success show" do
      before do
        log_in user
        get :show, params: {id: user.id}
      end

      it "assign @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end

    context "fail when user not login" do
      before do
        get :show, params: {id: user.id}
      end

      it_behaves_like "show flash not login"

      it_behaves_like "redirect to login page"
    end

    context "fail when user not found" do
      before do
        log_in user
        get :show, params: {id: -1}
      end

      it_behaves_like "show flash user not found"

      it_behaves_like "redirect to home page"
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "create a new empty user" do
      expect(assigns(:user)).to be_a_new(User)
    end

    it "render signup page" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "success create" do
      let(:user_params) {attributes_for :user}
      before do
        post :create, params: {user: user_params}
      end

      it "not activated when created" do
        expect(assigns(:user).activated).to be_falsey
      end

      it "not have activated time" do
        expect(assigns(:user).activated_at).to be_nil
      end

      it "show flash mail check" do
        expect(flash[:info]).to eq(I18n.t "flash.mail_check")
      end

      it_behaves_like "redirect to home page"
    end

    context "fail when user params invaild" do
      let(:user_params) {attributes_for(:user, name: "")}
      before do
        post :create, params: {user: user_params}
      end

      it "have errors" do
        expect(assigns(:user).errors.count).not_to eq(0)
      end

      it "render signup page" do
        expect(response).to render_template(:new)
      end
    end
  end
end
